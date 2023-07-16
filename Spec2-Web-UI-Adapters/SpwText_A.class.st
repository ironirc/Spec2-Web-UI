Class {
	#name : #'SpwText_A',
	#superclass : #'SpwBaseText_A',
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #visiting }
SpwText_A >> accept: aString notifying: aNotifyier [

	^ super 
		accept: (aString ifNotNil: [ aString asString ])
		notifying: aNotifyier
]

{ #category : #initialization }
SpwText_A >> addFocusRotationKeyBindings [
	"Text areas needs to be able to process tab. Cancel the binding."
]

{ #category : #'protocol - shortcuts' }
SpwText_A >> bindKeyCombination: aShortcut toAction: aBlock [ 

	self widgetDo: [ :w | 
		w textArea
			bindKeyCombination: aShortcut 
			toAction: aBlock ]
]

{ #category : #factory }
SpwText_A >> buildWidget [
	"| newWidget |
	
	newWidget := (SpRubScrolledTextMorph on: self)
		getTextSelector: #getText;
		setTextSelector: #accept:notifying:;
		getSelectionSelector: #readSelection;
		menuProvider: self selector: #codePaneMenu:shifted:;
		setSelectionSelector: #setSelection:;
		ghostText: self placeholder;
		beWrapped;
		enabled: self enabled;
		askBeforeDiscardingEdits: self askBeforeDiscardingEdits;
		autoAccept: true;
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		setBalloonText: self help;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		registerScrollChanges: #scrollValueChanged:;
		hScrollbarShowWhenNeeded;
		yourself.
	
	self setEditable: self presenter isEditable to: newWidget.
	self setEditingModeFor: newWidget.
	self setText: self presenter text to: newWidget.
	self presenter selectionInterval 
		ifNotNil: [  :anInterval | self selectionInterval: anInterval on: newWidget ].

	self setWrapWord: self presenter isWrapWord to: newWidget.	
	self setUndoRedo: self presenter hasUndoRedoHistory to: newWidget. 
	self presenter whenTextChangedDo: [ :text | 
		self setText: text to: newWidget ].
	self presenter whenSelectionChangedDo: [ :selectionInterval | 
		self selectionInterval: selectionInterval ].
	self presenter whenPlaceholderChangedDo: [ :text | 
		self setGhostText: text to: newWidget ].
	self presenter whenEditableChangedDo: [ :value | 
		self setEditable: value to: newWidget ].
	self presenter whenWrapWordChangedDo: [ :value | 
		self setWrapWord: value to: newWidget ].
	
	^ newWidget"
		| rw msg |
	rw := self  newRemoteWidget.
	msg := SpS2cUpdateInputElement new.
	msg elementId: rw id.
	msg tag: 'input'.
	msg textContent: self label.
	msg events: #( click ).
	msg styles: { 
			('background-color' -> ('#' , self color asHexString)).
			('flex-grow' -> 1) }.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.

	^ rw

]

{ #category : #'widget API' }
SpwText_A >> codePaneMenu: aMenu shifted: shifted [

	| menuPresenter |
	menuPresenter := self model contextMenu value
		                 ifNotNil: [ :contextMenu | contextMenu ]
		                 ifNil: [ SpMenuPresenter new ].
	self presenter hasEditionContextMenu ifTrue: [ 
		self presenter editionContextMenu menuGroups do: [ :each | 
			menuPresenter addMenuGroup: each ] ].
	^ SpBindings
		  value: self model application adapterBindings
		  during: [ menuPresenter value build ]
]

{ #category : #commands }
SpwText_A >> copyText [

	self editor copySelection
]

{ #category : #'widget API' }
SpwText_A >> cursorPosition [

	^ self widgetDo: [ :w |
		w textArea selectionStart
			ifNotNil: [ :sel | self linePositionOf: sel ] ]
]

{ #category : #'widget API' }
SpwText_A >> cursorPositionIndex: index [ 

	self widgetDo: [ :w | w textArea pointBlock: (w textArea paragraph characterBlockForIndex: index) ]
]

{ #category : #commands }
SpwText_A >> cutText [

	self editor cut
]

{ #category : #private }
SpwText_A >> editor [

	^ widget textArea editor
]

{ #category : #private }
SpwText_A >> eventHandlerReceiver: aWidget [

	^ aWidget textArea
]

{ #category : #commands }
SpwText_A >> findNextText [

	self editor findAgain
]

{ #category : #commands }
SpwText_A >> findText [

	self editor find
]

{ #category : #api }
SpwText_A >> lineAtCursorPosition [

	^ self widgetDo: [ :w | 
		w textArea editor lineAtCursorPosition ]
]

{ #category : #private }
SpwText_A >> linePositionOf: sel [

	| textLine linePosition |
	textLine := sel textLine.
	linePosition := sel stringIndex - textLine first + 1.
	^ linePosition @ textLine lineNumber
]

{ #category : #commands }
SpwText_A >> pasteText [

	self editor paste
]

{ #category : #styling }
SpwText_A >> presenterStyles [
	"The presenters in the style"

	^ self presenter scrollBarStyles, self presenter styles 
]

{ #category : #commands }
SpwText_A >> selectAndPasteText [

	self editor pasteRecent
]

{ #category : #private }
SpwText_A >> setEditable: aBoolean to: aWidget [

	aWidget textArea readOnly: aBoolean not
]

{ #category : #private }
SpwText_A >> setGhostText: text to: aWidget [

	aWidget ghostText: text
]

{ #category : #private }
SpwText_A >> setText: text to: aWidget [

	updating ifTrue: [ ^ self ].

	aWidget textArea editingState clearUndoManager: nil.
	aWidget setText: text.
	self updateExtentPropagationOf: text on: aWidget
]

{ #category : #factory }
SpwText_A >> setUndoRedo: aBoolean to: newWidget [

	newWidget textArea editingState undoManager: (aBoolean 
		ifTrue: [ HistoryIterator new ]
		ifFalse: [ SpNullHistoryIterator new ])
]

{ #category : #private }
SpwText_A >> setWrapWord: aBoolean to: aWidget [

	aBoolean 
		ifTrue: [ aWidget beWrapped ]
		ifFalse: [ aWidget beNotWrapped ]
]

{ #category : #private }
SpwText_A >> updateExtentPropagationOf: string on: aWidget [
	| stringMorph width height |

	(self presenter isPropagateNaturalWidth 
		or: [ self presenter isPropagateNaturalHeight ])
		ifFalse: [ ^ self ].

	"This is an incredible ugly hack because what should be the correct way of doing it: 
	 Font>>widthOfString: does not works (because it fails to take into account kerning).
	 Why it works on the Editing area is a mystery. 
	 BUT! It does not work for monospaced fonts! (again, no idea why)"
	stringMorph := RubEditingArea new 
		font: aWidget font;
		updateTextWith: string asString.

	width := stringMorph width + 12" min: self currentWorld width / 3".
	self presenter isPropagateNaturalWidth 
		ifTrue: [ aWidget width: width ].

	self presenter isPropagateNaturalHeight 
		ifTrue: [ 
			height := ((stringMorph
				beWrapped;
				width: width;
				yourself) height + 2)"min: self currentWorld height / 3". 
			aWidget height: height ]
]
