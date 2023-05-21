Class {
	#name : #SpPharoJsBaseTextAdapter,
	#superclass : #SpAbstractPharoJsAdapter,
	#traits : 'TViewModel',
	#classTraits : 'TViewModel classTrait',
	#instVars : [
		'selection',
		'updating'
	],
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #testing }
SpPharoJsBaseTextAdapter class >> isAbstract [

	^ self name = #SpMorphicBaseTextAdapter
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> accept: aString notifying: aNotifyier [

	updating := true.
	[
		self presenter text: aString.
		"Raise an announcement"
		self presenter changed: #clearUserEdits]
	ensure: [ 
		updating := false ].

	^ true
]

{ #category : #accessing }
SpPharoJsBaseTextAdapter >> acceptAllowed [

	^ self widget editingMode acceptAllowed
]

{ #category : #initialization }
SpPharoJsBaseTextAdapter >> addKeyBindingsTo: aMorph [

	super addKeyBindingsTo: aMorph.
	self 
		bindKeyCombination: Character escape asKeyCombination 
			toAction: [ :target :morph :event | self bubbleUpEvent: event ];
		bindKeyCombination: $t meta 
			toAction: [ self showContextMenu ]
]

{ #category : #accessing }
SpPharoJsBaseTextAdapter >> announcer [

	^ self model announcer
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> askBeforeDiscardingEdits [

	^ self model askBeforeDiscardingEdits
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> askBeforeDiscardingEdits: aBoolean [

	self widget askBeforeDiscardingEdits: aBoolean
]

{ #category : #private }
SpPharoJsBaseTextAdapter >> bubbleUpEvent: anEvent [

	anEvent wasHandled: false.
	self presenter window adapter widget handleEvent: anEvent
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> canChangeText [

	^ self widget textArea canChangeText
]

{ #category : #'undo-redo' }
SpPharoJsBaseTextAdapter >> clearUndoManager [

	self widget textArea editingState clearUndoManager: nil
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> clearUserEditFlag [

	self model text: self getText.
	self changed: #clearUserEdits
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> codePaneMenu: aMenu shifted: shifted [

	| menuPresenter |
	menuPresenter := self model contextMenu.
	menuPresenter ifNil: [ ^ nil ].
	^ SpBindings
		  value: self model application adapterBindings
		  during: [ menuPresenter value build ]
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> cursorPositionIndex [

	self widgetDo: [ :w | ^ w textArea editor pointIndex ]
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> cursorPositionIndex: index [ 

	self subclassResponsibility
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> font: aFont [

	self widgetDo: [ :w | w font: aFont ]
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> getText [

	^ self model text
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> hasEditingConflicts: aBoolean [
 
	self widgetDo: [ :w | w hasEditingConflicts: aBoolean ]
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> hasUnacceptedEdits: aBoolean [

	self model hasUnacceptedEdits: aBoolean
]

{ #category : #initialization }
SpPharoJsBaseTextAdapter >> initialize [

	super initialize.
	updating := false
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> insert: aString at: positionIndex [

	| text |
	text := self getText.
	text := String streamContents: [ :stream | 
		        stream << (text copyFrom: 1 to: positionIndex).
		        stream << aString.
		        text size > positionIndex ifTrue: [ 
			        stream << (text copyFrom: positionIndex + 1 to: text size) ] ].

	self presenter text: text
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> notify: errorMessage at: position in: sourceCode [

	self widgetDo: [ :w | 
		w notify: errorMessage at: position in: sourceCode ]
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> pendingText [

	^ self widgetDo: [ :w | w text ]
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> pendingText: aText [

	self widgetDo: [ :w | 
		w 
			setText: aText;
			hasUnacceptedEdits: true ]
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> placeholder [

	^ self model placeholder
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> placeholder: aText [

	^ self model placeholder: aText
]

{ #category : #'presenter events' }
SpPharoJsBaseTextAdapter >> placeholderChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg attributes: { 'placeholder' -> self placeholder }.
	self sendUpdateMessageToClient: msg
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> readSelection [

	^ self model readSelection
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> scrollValueChanged: aValue [

	self model scrollValue: aValue step
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> selectAll [

	"self widgetDo: [ :w | w selectAll ]"

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg selectAll: true.
	self sendUpdateMessageToClient: msg
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> selectFrom: nodeStart to: nodeStop [

	self widget selectFrom: nodeStart to: nodeStop
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> selectLine [

	self widgetDo: [ :w |
		self selectionInterval: w textArea editor lineIntervalAtCursorPosition ]
]

{ #category : #accessing }
SpPharoJsBaseTextAdapter >> selection [

	^ selection
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> selectionInterval [

	| msg envelope start end |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: widget.
	msg selectors: #( selectionStart selectionEnd ).
	envelope := self sendUpdateMessageToClient: msg.
	start := envelope msg results first value.
	end := envelope msg results last value.
	^ (start + 1) to: end
]

{ #category : #private }
SpPharoJsBaseTextAdapter >> selectionInterval: anInterval [

	self widgetDo: [ :w | 
		self selectionInterval: anInterval on: w ]
]

{ #category : #private }
SpPharoJsBaseTextAdapter >> selectionInterval: anInterval on: aWidget [
	| interval |
		
	interval := anInterval ifNil: [ 1 to: 0 ].

	aWidget textArea editor 
		selectFrom: interval first 
		to: interval last
]

{ #category : #private }
SpPharoJsBaseTextAdapter >> setEditingModeFor: textArea [

	textArea beForPlainText
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> setHasUnacceptedEdits: aBoolean [

	self widgetDo: [ :w | w basicHasUnacceptedEdits: aBoolean ]
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> setScrollValue: aValue [

	self widgetDo: [ :w | 
		w scrollPane
			hScrollbarValue: aValue x;
			vScrollbarValue: aValue y;
			updateScrollbars ]
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> setSelection: interval [

	selection := interval
]

{ #category : #'spec protocol' }
SpPharoJsBaseTextAdapter >> setSelectionFromModel: aSelection [

	self widget ifNotNil: [ :w | w setSelection: aSelection ]
]

{ #category : #initialization }
SpPharoJsBaseTextAdapter >> showContextMenu [

	self widgetDo: [ :w | 
		(w textArea getMenu: false) ifNotNil: [ :menu | 
			menu
				invokeAt: w position + w textArea cursor center
				in: self currentWorld ] ]
]

{ #category : #factory }
SpPharoJsBaseTextAdapter >> subcribeToModel [

	"how else to hook up to all possible change events of the presenter?"

	super subcribeToModel.
	self subcribeToAll: #( text placeholder  )
]

{ #category : #'presenter events' }
SpPharoJsBaseTextAdapter >> textChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg value: self model text.
	self sendUpdateMessageToClient: msg
]

{ #category : #emulating }
SpPharoJsBaseTextAdapter >> type: aString [

	self widget setText: aString
]

{ #category : #emulating }
SpPharoJsBaseTextAdapter >> typeByChar: aString [

	aString do: [ :each | 
		self 
			keyPressed: each 
			shift: each isUppercase
			meta: false 
			control: false 
			option: false ]
]

{ #category : #'widget API' }
SpPharoJsBaseTextAdapter >> wantsVisualFeedback [

	^ self model wantsVisualFeedback
]
