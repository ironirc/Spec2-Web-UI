Class {
	#name : #'SpwBaseText_A',
	#superclass : #SpwAbstractAdapter,
	#traits : 'TViewModel',
	#classTraits : 'TViewModel classTrait',
	#instVars : [
		'selection',
		'updating'
	],
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #testing }
SpwBaseText_A class >> isAbstract [

	^ self == SpwBaseText_A
]

{ #category : #'widget API' }
SpwBaseText_A >> accept: aString notifying: notUsed [

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
SpwBaseText_A >> acceptAllowed [

	^ self widget editingMode acceptAllowed
]

{ #category : #initialization }
SpwBaseText_A >> addKeyBindingsTo: aMorph [

	super addKeyBindingsTo: aMorph.
	self 
		bindKeyCombination: Character escape asKeyCombination 
			toAction: [ :target :morph :event | self bubbleUpEvent: event ];
		bindKeyCombination: $t meta 
			toAction: [ self showContextMenu ]
]

{ #category : #accessing }
SpwBaseText_A >> announcer [

	^ self model announcer
]

{ #category : #'widget API' }
SpwBaseText_A >> askBeforeDiscardingEdits [

	^ self model askBeforeDiscardingEdits
]

{ #category : #'spec protocol' }
SpwBaseText_A >> askBeforeDiscardingEdits: aBoolean [

	self widget askBeforeDiscardingEdits: aBoolean
]

{ #category : #private }
SpwBaseText_A >> bubbleUpEvent: anEvent [

	anEvent wasHandled: false.
	self presenter window adapter widget handleEvent: anEvent
]

{ #category : #'spec protocol' }
SpwBaseText_A >> canChangeText [

	^ self widget textArea canChangeText
]

{ #category : #'undo-redo' }
SpwBaseText_A >> clearUndoManager [

	self widget textArea editingState clearUndoManager: nil
]

{ #category : #'widget API' }
SpwBaseText_A >> clearUserEditFlag [

	self model text: self getText.
	self changed: #clearUserEdits
]

{ #category : #'widget API' }
SpwBaseText_A >> codePaneMenu: aMenu shifted: shifted [

	| menuPresenter |
	menuPresenter := self model contextMenu.
	menuPresenter ifNil: [ ^ nil ].
	^ SpBindings
		  value: self model application adapterBindings
		  during: [ menuPresenter value build ]
]

{ #category : #'spec protocol' }
SpwBaseText_A >> cursorPositionIndex [

	self widgetDo: [ :w | ^ w textArea editor pointIndex ]
]

{ #category : #'widget API' }
SpwBaseText_A >> cursorPositionIndex: index [ 

	self subclassResponsibility
]

{ #category : #'widget API' }
SpwBaseText_A >> font: aFont [

	self widgetDo: [ :w | w font: aFont ]
]

{ #category : #'widget API' }
SpwBaseText_A >> getText [

	^ self model text
]

{ #category : #'spec protocol' }
SpwBaseText_A >> hasEditingConflicts: aBoolean [
 
	self widgetDo: [ :w | w hasEditingConflicts: aBoolean ]
]

{ #category : #'spec protocol' }
SpwBaseText_A >> hasUnacceptedEdits: aBoolean [

	self model hasUnacceptedEdits: aBoolean
]

{ #category : #initialization }
SpwBaseText_A >> initialize [

	super initialize.
	updating := false
]

{ #category : #'spec protocol' }
SpwBaseText_A >> insert: aString at: positionIndex [

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
SpwBaseText_A >> notify: errorMessage at: position in: sourceCode [

	self widgetDo: [ :w | 
		w notify: errorMessage at: position in: sourceCode ]
]

{ #category : #'spec protocol' }
SpwBaseText_A >> pendingText [

	^ self widgetDo: [ :w | w text ]
]

{ #category : #'spec protocol' }
SpwBaseText_A >> pendingText: aText [

	self widgetDo: [ :w | 
		w 
			setText: aText;
			hasUnacceptedEdits: true ]
]

{ #category : #'widget API' }
SpwBaseText_A >> placeholder [

	^ self model placeholder
]

{ #category : #'widget API' }
SpwBaseText_A >> placeholder: aText [

	^ self model placeholder: aText
]

{ #category : #'presenter events' }
SpwBaseText_A >> placeholderChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg attributes: { 'placeholder' -> self placeholder }.
	self sendMessageToClient: msg
]

{ #category : #'widget API' }
SpwBaseText_A >> readSelection [

	^ self model readSelection
]

{ #category : #'widget API' }
SpwBaseText_A >> scrollValueChanged: aValue [

	self model scrollValue: aValue step
]

{ #category : #'spec protocol' }
SpwBaseText_A >> selectAll [

	"self widgetDo: [ :w | w selectAll ]"

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg selectAll: true.
	self sendMessageToClient: msg
]

{ #category : #'spec protocol' }
SpwBaseText_A >> selectFrom: nodeStart to: nodeStop [

	self widget selectFrom: nodeStart to: nodeStop
]

{ #category : #'spec protocol' }
SpwBaseText_A >> selectLine [

	self widgetDo: [ :w |
		self selectionInterval: w textArea editor lineIntervalAtCursorPosition ]
]

{ #category : #accessing }
SpwBaseText_A >> selection [

	^ selection
]

{ #category : #'presenter events' }
SpwBaseText_A >> selectionChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg selectionStart: model selection first - 1.
	msg selectionEnd: model selection last.
	self sendMessageToClient: msg
]

{ #category : #'spec protocol' }
SpwBaseText_A >> selectionInterval [

	| msg envelope start end |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: widget id.
	msg selectors: #( selectionStart selectionEnd ).
	envelope := self sendMessageToClient: msg.
	start := envelope msg results first value.
	end := envelope msg results last value.
	^ (start + 1) to: end
]

{ #category : #private }
SpwBaseText_A >> selectionInterval: anInterval [

	self widgetDo: [ :w | 
		self selectionInterval: anInterval on: w ]
]

{ #category : #private }
SpwBaseText_A >> selectionInterval: anInterval on: aWidget [
	| interval |
		
	interval := anInterval ifNil: [ 1 to: 0 ].

	aWidget textArea editor 
		selectFrom: interval first 
		to: interval last
]

{ #category : #private }
SpwBaseText_A >> setEditingModeFor: textArea [

	textArea beForPlainText
]

{ #category : #'spec protocol' }
SpwBaseText_A >> setHasUnacceptedEdits: aBoolean [

	self widgetDo: [ :w | w basicHasUnacceptedEdits: aBoolean ]
]

{ #category : #'widget API' }
SpwBaseText_A >> setScrollValue: aValue [

	self widgetDo: [ :w | 
		w scrollPane
			hScrollbarValue: aValue x;
			vScrollbarValue: aValue y;
			updateScrollbars ]
]

{ #category : #'widget API' }
SpwBaseText_A >> setSelection: interval [

	selection := interval.
	(self model selection = interval) ifFalse: [ self model selectionInterval: interval ]
]

{ #category : #'spec protocol' }
SpwBaseText_A >> setSelectionFromModel: aSelection [
	| msg |
	self flag: 'TODO ... beware for infinite loops'.
	"self widget ifNotNil: [ :w | w setSelection: aSelection ]"
	
"instead see SpPharoJsBaseTextAdapter>>#selectionChanged 

	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg selectionStart: aSelection first - 1.
	msg selectionEnd: aSelection last.
	self sendUpdateMessageToClient: msg"
]

{ #category : #initialization }
SpwBaseText_A >> showContextMenu [

	self widgetDo: [ :w | 
		(w textArea getMenu: false) ifNotNil: [ :menu | 
			menu
				invokeAt: w position + w textArea cursor center
				in: self currentWorld ] ]
]

{ #category : #factory }
SpwBaseText_A >> subcribeToModel [

	"how else to hook up to all possible change events of the presenter?"

	super subcribeToModel.
	self subcribeToAll: #( text placeholder selection  )
]

{ #category : #'presenter events' }
SpwBaseText_A >> textChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget id.
	msg value: self model text.
	self sendMessageToClient: msg
]

{ #category : #emulating }
SpwBaseText_A >> type: aString [

	self widget setText: aString
]

{ #category : #emulating }
SpwBaseText_A >> typeByChar: aString [

	aString do: [ :each | 
		self 
			keyPressed: each 
			shift: each isUppercase
			meta: false 
			control: false 
			option: false ]
]

{ #category : #'widget API' }
SpwBaseText_A >> wantsVisualFeedback [

	^ self model wantsVisualFeedback
]
