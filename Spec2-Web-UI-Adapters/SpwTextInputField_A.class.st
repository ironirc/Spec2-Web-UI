Class {
	#name : #'SpwTextInputField_A',
	#superclass : #'SpwBaseText_A',
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #constants }
SpwTextInputField_A class >> remoteWidgetClass [

	^ SpwTextInputField_RW
]

{ #category : #'widget API' }
SpwTextInputField_A >> accept: aText notifying: aNotifyier [
	"We use #asString because rubric send Text instead of strings."

	super
		accept: aText asString 
		notifying: aNotifyier
]

{ #category : #factory }
SpwTextInputField_A >> buildWidget [
	"| newWidget |

	newWidget := (SpRubTextFieldMorph on: self)
		getTextSelector: #getText;
		setTextSelector: #accept:notifying:;
		getSelectionSelector: #readSelection;
		menuProvider: self selector: #codePaneMenu:shifted:;
		setSelectionSelector: #setSelection:;
		entryCompletion: self entryCompletion;
		ghostText: self getPlaceholderText;
		encrypted: self encrypted;
		enabled: self enabled;
		askBeforeDiscardingEdits: self askBeforeDiscardingEdits;
		autoAccept: true;
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		setBalloonText: self help;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		maxLength: self presenter maxLength;
		yourself.

	self presenter selectionInterval 
		ifNotNil: [  :anInterval | self selectionInterval: anInterval on: newWidget ].

	self presenter whenTextChangedDo: [ :text | newWidget setText: text ].
	self presenter whenSelectionChangedDo: [ :selectionInterval | 
		self selectionInterval: selectionInterval ].
	self presenter whenPlaceholderChangedDo: [ :text | 
		newWidget ghostText: (text ifNotNil: [ :aString | 
			aString localizedForPresenter: self presenter ]) ].
	self presenter whenPasswordChangedDo: [ :isPassword | 
		newWidget encrypted: isPassword ].
	self presenter whenMaxLengthChangedDo: [ :length | 
		newWidget maxLength: length ].
	self setEditable: self presenter isEditable to: newWidget. 
	self presenter whenEditableChangedDo: [ :value | 
		self setEditable: value to: newWidget ].

	^ newWidget"

	| rw   |
	rw := self newRemoteWidget.
	rw sendCreateMessage. 
	^ rw
]

{ #category : #'widget API' }
SpwTextInputField_A >> cursorPositionIndex: index [ 

	self widgetDo: [ :w | ^ w textArea editor selectAt: index ]
]

{ #category : #private }
SpwTextInputField_A >> deliverResponse: msg [ 

	self halt. 
]

{ #category : #'presenter events' }
SpwTextInputField_A >> editableChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.	
	msg readOnly: self model isEditable not.
	self sendMessageToClient: msg
]

{ #category : #'presenter events' }
SpwTextInputField_A >> enabledChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg disabled: self model isEnabled not.
	self sendMessageToClient: msg
]

{ #category : #'spec protocol' }
SpwTextInputField_A >> encrypted: aBoolean [

	self widgetDo: [ :w | 
		w encrypted: aBoolean.
		w changed ]
]

{ #category : #private }
SpwTextInputField_A >> eventHandlerReceiver: aWidget [

	^ aWidget textArea
]

{ #category : #private }
SpwTextInputField_A >> getPlaceholderText [

	^ self presenter placeholder ifNotNil: [ :aString | 
		aString localizedForPresenter: self presenter ]
]

{ #category : #'widget events' }
SpwTextInputField_A >> handleBlur: e [

	
]

{ #category : #'widget events' }
SpwTextInputField_A >> handleChange: e [


]

{ #category : #'widget events' }
SpwTextInputField_A >> handleInput: e [

	"('typed ' , e key asString ) crTrace"

	self
		muteModelAspect: #text
		while: [ self accept: e newValue notifying: nil ]
]

{ #category : #'widget events' }
SpwTextInputField_A >> handleKeydown: e [

	"('typed ' , e key asString ) crTrace"

]

{ #category : #'widget events' }
SpwTextInputField_A >> handleSelect: e [

	self
		muteModelAspect: #selection
		while: [ self setSelection: (e start + 1 to: e end) ]
]

{ #category : #factory }
SpwTextInputField_A >> htmlInputType [
	self model isPassword ifTrue: [ ^'password' ].
	^'text'
]

{ #category : #factory }
SpwTextInputField_A >> htmlMaxLength [

	^ String streamContents: [ :ws | 
		  self model maxLength ifNotNil: [ :maxLen | 
			  (maxLen > 0) ifTrue: [ ws << maxLen asString ] ] ]
]

{ #category : #testing }
SpwTextInputField_A >> isPassword [
	
	^ self widget font isKindOf: FixedFaceFont
]

{ #category : #'presenter events' }
SpwTextInputField_A >> isPasswordChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.	
	msg type: self htmlInputType.
	self sendMessageToClient: msg
]

{ #category : #'presenter events' }
SpwTextInputField_A >> maxLengthChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg addAttribute: 'maxLength' value: self htmlMaxLength.
	self sendMessageToClient: msg
]

{ #category : #private }
SpwTextInputField_A >> setEditable: aBoolean to: aWidget [

	aWidget textArea readOnly: aBoolean not
]

{ #category : #'model-widget-bindings' }
SpwTextInputField_A >> subcribeToModel [

	"how else to hook up to all possible change events of the presenter?"

	super subcribeToModel.
	self subcribeToAll: #(enabled editable isPassword maxLength visible )
]

{ #category : #accessing }
SpwTextInputField_A >> text: aString [

	widget
		setText: aString;
		acceptTextInModel
]

{ #category : #emulating }
SpwTextInputField_A >> widgetEventReceiver [
	
	^ widget
]
