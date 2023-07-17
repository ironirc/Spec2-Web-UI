Class {
	#name : #'SpwTextInputField_RW',
	#superclass : #SpwAbstractRemoteWidget,
	#category : #'Spec2-Web-UI-Adapters-Widget'
}

{ #category : #accessing }
SpwTextInputField_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: self id.
	msg events: #( 'input' 'select' ).
	msg attributes: {
			('method' -> thisContext method printString).
			('placeholder' -> self model placeholder).
			('type' -> self adaptor htmlInputType).
			('maxLength' -> self adaptor htmlMaxLength) }.
	msg readOnly: self model isEditable not.
	msg disabled: self model isEnabled not.
	msg visible: self model isVisible.
	msg value: self model text.
	self sendMessageToClient: msg
]
