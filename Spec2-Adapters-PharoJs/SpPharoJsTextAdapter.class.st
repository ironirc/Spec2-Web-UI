Class {
	#name : #SpPharoJsTextAdapter,
	#superclass : #SpPharoJsBaseTextAdapter,
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #visiting }
SpPharoJsTextAdapter >> accept: aString notifying: aNotifyier [

	^ super 
		accept: (aString ifNotNil: [ aString asString ])
		notifying: aNotifyier
]

{ #category : #initialization }
SpPharoJsTextAdapter >> addFocusRotationKeyBindings [
	"Text areas needs to be able to process tab. Cancel the binding."
]

{ #category : #'protocol - shortcuts' }
SpPharoJsTextAdapter >> bindKeyCombination: aShortcut toAction: aBlock [ 

	self widgetDo: [ :w | 
		w textArea
			bindKeyCombination: aShortcut 
			toAction: aBlock ]
]

{ #category : #factory }
SpPharoJsTextAdapter >> buildWidget [
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
		| id msg |
	id := self class nextIdString.
	msg := SpS2cUpdateElement new.
	msg elementId: id.
	msg tag: 'input'.
	msg textContent: self label.
	msg events: #( click ).
	msg styles: { 
			('background-color' -> ('#' , self color asHexString)).
			('flex-grow' -> 1) }.
	msg attributes: { ('method' -> thisContext method printString) }.
	self sendUpdateMessageToClient: msg.

	^ id

]

{ #category : #'widget API' }
SpPharoJsTextAdapter >> codePaneMenu: aMenu shifted: shifted [

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
SpPharoJsTextAdapter >> copyText [

	self editor copySelection
]

{ #category : #'widget API' }
SpPharoJsTextAdapter >> cursorPosition [

	^ self widgetDo: [ :w |
		w textArea selectionStart
			ifNotNil: [ :sel | self linePositionOf: sel ] ]
]

{ #category : #'widget API' }
SpPharoJsTextAdapter >> cursorPositionIndex: index [ 

	self widgetDo: [ :w | w textArea pointBlock: (w textArea paragraph characterBlockForIndex: index) ]
]

{ #category : #commands }
SpPharoJsTextAdapter >> cutText [

	self editor cut
]

{ #category : #private }
SpPharoJsTextAdapter >> editor [

	^ widget textArea editor
]

{ #category : #private }
SpPharoJsTextAdapter >> eventHandlerReceiver: aWidget [

	^ aWidget textArea
]

{ #category : #commands }
SpPharoJsTextAdapter >> findNextText [

	self editor findAgain
]

{ #category : #commands }
SpPharoJsTextAdapter >> findText [

	self editor find
]

{ #category : #api }
SpPharoJsTextAdapter >> lineAtCursorPosition [

	^ self widgetDo: [ :w | 
		w textArea editor lineAtCursorPosition ]
]

{ #category : #private }
SpPharoJsTextAdapter >> linePositionOf: sel [

	| textLine linePosition |
	textLine := sel textLine.
	linePosition := sel stringIndex - textLine first + 1.
	^ linePosition @ textLine lineNumber
]

{ #category : #commands }
SpPharoJsTextAdapter >> pasteText [

	self editor paste
]

{ #category : #styling }
SpPharoJsTextAdapter >> presenterStyles [
	"The presenters in the style"

	^ self presenter scrollBarStyles, self presenter styles 
]

{ #category : #commands }
SpPharoJsTextAdapter >> selectAndPasteText [

	self editor pasteRecent
]

{ #category : #private }
SpPharoJsTextAdapter >> setEditable: aBoolean to: aWidget [

	aWidget textArea readOnly: aBoolean not
]

{ #category : #private }
SpPharoJsTextAdapter >> setGhostText: text to: aWidget [

	aWidget ghostText: text
]

{ #category : #private }
SpPharoJsTextAdapter >> setText: text to: aWidget [

	updating ifTrue: [ ^ self ].

	aWidget textArea editingState clearUndoManager: nil.
	aWidget setText: text.
	self updateExtentPropagationOf: text on: aWidget
]

{ #category : #factory }
SpPharoJsTextAdapter >> setUndoRedo: aBoolean to: newWidget [

	newWidget textArea editingState undoManager: (aBoolean 
		ifTrue: [ HistoryIterator new ]
		ifFalse: [ SpNullHistoryIterator new ])
]

{ #category : #private }
SpPharoJsTextAdapter >> setWrapWord: aBoolean to: aWidget [

	aBoolean 
		ifTrue: [ aWidget beWrapped ]
		ifFalse: [ aWidget beNotWrapped ]
]

{ #category : #private }
SpPharoJsTextAdapter >> updateExtentPropagationOf: string on: aWidget [
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
