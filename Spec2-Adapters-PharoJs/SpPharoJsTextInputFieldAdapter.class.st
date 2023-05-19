Class {
	#name : #SpPharoJsTextInputFieldAdapter,
	#superclass : #SpPharoJsBaseTextAdapter,
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #'widget API' }
SpPharoJsTextInputFieldAdapter >> accept: aText notifying: aNotifyier [
	"We use #asString because rubric send Text instead of strings."

	super
		accept: aText asString 
		notifying: aNotifyier
]

{ #category : #factory }
SpPharoJsTextInputFieldAdapter >> buildWidget [

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

	| id msg |
	id := self class nextIdString.
	msg := SpS2cUpdateInputElement new.
	msg elementId: id.
	msg events: #(  'input'  ).
	msg styles: { 
			('flex-grow' -> 1).
			('flex' -> 1) }.
	msg attributes: { 
			('method' -> thisContext method printString).
			('placeholder' -> self model placeholder).
			('type' -> self htmlInputType).
			('maxLength' -> self htmlMaxLength) }.

	msg readOnly: self model isEditable not.
	msg disabled: self model isEnabled not.
	msg visible: self model isVisible.
	msg value: self model text.
	self sendUpdateMessageToClient: msg.
	^ id
]

{ #category : #'widget API' }
SpPharoJsTextInputFieldAdapter >> cursorPositionIndex: index [ 

	self widgetDo: [ :w | ^ w textArea editor selectAt: index ]
]

{ #category : #private }
SpPharoJsTextInputFieldAdapter >> deliverResponse: msg [ 

	self halt. 
]

{ #category : #'presenter events' }
SpPharoJsTextInputFieldAdapter >> editableChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.	
	msg readOnly: self model isEditable not.
	self sendUpdateMessageToClient: msg
]

{ #category : #'presenter events' }
SpPharoJsTextInputFieldAdapter >> enabledChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg disabled: self model isEnabled not.
	self sendUpdateMessageToClient: msg
]

{ #category : #'widget API' }
SpPharoJsTextInputFieldAdapter >> encrypted [
	^ self model isPassword
]

{ #category : #'spec protocol' }
SpPharoJsTextInputFieldAdapter >> encrypted: aBoolean [

	self widgetDo: [ :w | 
		w encrypted: aBoolean.
		w changed ]
]

{ #category : #'widget API' }
SpPharoJsTextInputFieldAdapter >> entryCompletion [

	^ self model entryCompletion
]

{ #category : #private }
SpPharoJsTextInputFieldAdapter >> eventHandlerReceiver: aWidget [

	^ aWidget textArea
]

{ #category : #private }
SpPharoJsTextInputFieldAdapter >> getPlaceholderText [

	^ self presenter placeholder ifNotNil: [ :aString | 
		aString localizedForPresenter: self presenter ]
]

{ #category : #'widget events' }
SpPharoJsTextInputFieldAdapter >> handleBlur: e [

	
]

{ #category : #'widget events' }
SpPharoJsTextInputFieldAdapter >> handleChange: e [


]

{ #category : #'widget events' }
SpPharoJsTextInputFieldAdapter >> handleInput: e [

	"('typed ' , e key asString ) crTrace"
	self accept: e newValue notifying: nil

]

{ #category : #'widget events' }
SpPharoJsTextInputFieldAdapter >> handleKeydown: e [

	"('typed ' , e key asString ) crTrace"

]

{ #category : #factory }
SpPharoJsTextInputFieldAdapter >> htmlInputType [
	self model isPassword ifTrue: [ ^'password' ].
	^'text'
]

{ #category : #factory }
SpPharoJsTextInputFieldAdapter >> htmlMaxLength [

	^ String streamContents: [ :ws | 
		  self model maxLength ifNotNil: [ :maxLen | 
			  (maxLen > 0) ifTrue: [ ws << maxLen asString ] ] ]
]

{ #category : #testing }
SpPharoJsTextInputFieldAdapter >> isPassword [
	
	^ self widget font isKindOf: FixedFaceFont
]

{ #category : #'presenter events' }
SpPharoJsTextInputFieldAdapter >> isPasswordChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.	
	msg type: self htmlInputType.
	self sendUpdateMessageToClient: msg
]

{ #category : #'presenter events' }
SpPharoJsTextInputFieldAdapter >> maxLengthChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg addAttribute: 'maxLength' value: self htmlMaxLength.
	self sendUpdateMessageToClient: msg
]

{ #category : #private }
SpPharoJsTextInputFieldAdapter >> setEditable: aBoolean to: aWidget [

	aWidget textArea readOnly: aBoolean not
]

{ #category : #'model-widget-bindings' }
SpPharoJsTextInputFieldAdapter >> subcribeToModel [

	"how else to hook up to all possible change events of the presenter?"

	super subcribeToModel.
	self subcribeToAll: #(enabled editable isPassword maxLength visible )
]

{ #category : #accessing }
SpPharoJsTextInputFieldAdapter >> text: aString [

	widget
		setText: aString;
		acceptTextInModel
]

{ #category : #'presenter events' }
SpPharoJsTextInputFieldAdapter >> visibleChanged [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: widget.
	msg visible: self model isVisible.
	self sendUpdateMessageToClient: msg
]

{ #category : #emulating }
SpPharoJsTextInputFieldAdapter >> widgetEventReceiver [
	
	^ widget
]
