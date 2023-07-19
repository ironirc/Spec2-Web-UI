Class {
	#name : #'SpwTextInputField_RW',
	#superclass : #SpwAbstractRemoteWidget,
	#category : #'Spec2-Web-UI-Adapters-RemoteWidget'
}

{ #category : #accessing }
SpwTextInputField_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg tag: self tagName.
	msg elementId: self id.
	msg events: #( 'input' 'select' ).
	msg attributes: {
			('method' -> thisContext method printString).
			('placeholder' -> self model placeholder).
			('type' -> self adaptor htmlInputType).
			('maxLength' -> self adaptor htmlMaxLength) }.
	self model isEditable ifFalse: [
		msg addAttribute: 'readOnly' value: '' ].
	self model isEnabled ifFalse: [
		msg addAttribute: 'disabled' value: '' ].
	msg visible: self model isVisible.
	msg value: self model text.
	self sendMessageToClient: msg
]

{ #category : #accessing }
SpwTextInputField_RW >> tagName [

	^ SpwInputField_WC tagName
]

{ #category : #accessing }
SpwTextInputField_RW >> value: aValue [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: self id.
	msg value: aValue.
	self sendMessageToClient: msg
]
