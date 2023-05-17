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
	msg events: #( 'keydown' 'change' 'blur').
	msg styles: { ('flex-grow' -> 1) }.
	msg attributes: { 
			('method' -> thisContext method printString).
			('placeholder' -> self model placeholder).
			 }.
	msg value: self model text.
	self sendUpdateMessageToClient: msg.
	^ id
]

{ #category : #'widget API' }
SpPharoJsTextInputFieldAdapter >> cursorPositionIndex: index [ 

	self widgetDo: [ :w | ^ w textArea editor selectAt: index ]
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

	"('typed ' , e key asString ) crTrace"
]

{ #category : #'widget events' }
SpPharoJsTextInputFieldAdapter >> handleChange: e [

	"('typed ' , e key asString ) crTrace"
	self accept: e newValue notifying: nil

]

{ #category : #'widget events' }
SpPharoJsTextInputFieldAdapter >> handleKeydown: e [

	"('typed ' , e key asString ) crTrace"

]

{ #category : #testing }
SpPharoJsTextInputFieldAdapter >> isPassword [
	
	^ self widget font isKindOf: FixedFaceFont
]

{ #category : #private }
SpPharoJsTextInputFieldAdapter >> setEditable: aBoolean to: aWidget [

	aWidget textArea readOnly: aBoolean not
]

{ #category : #accessing }
SpPharoJsTextInputFieldAdapter >> text: aString [

	widget
		setText: aString;
		acceptTextInModel
]

{ #category : #emulating }
SpPharoJsTextInputFieldAdapter >> widgetEventReceiver [
	
	^ widget
]
