Class {
	#name : 'SpwTextInputField_RW',
	#superclass : 'SpwAbstractRemoteWidget',
	#category : 'Spec2-Web-UI-Adapters-RemoteWidget',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'RemoteWidget'
}

{ #category : 'accessing' }
SpwTextInputField_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg tag: self tagName.
	msg elementId: self id.
	msg events: #( 'input' 'select' ).
	msg attributes: {
			('placeholder' -> self model placeholder).
			('type' -> self adaptor htmlInputType).
			('maxLength' -> self adaptor htmlMaxLength) }.
	"('method' -> thisContext method printString)."
	self model isEditable ifFalse: [
		msg addAttribute: 'readOnly' value: '' ].
	self model isEnabled ifFalse: [
		msg addAttribute: 'disabled' value: '' ].
	msg visible: self model isVisible.
	msg value: self model text.
	self sendMessageToClient: msg.
	self model root adapter registerWidget: self
]

{ #category : 'accessing' }
SpwTextInputField_RW >> tagName [

	^ SpwInputField_WC tagName
]

{ #category : 'accessing' }
SpwTextInputField_RW >> value: aValue [

	| msg |
	msg := SpS2cUpdateInputElement new.
	msg elementId: self id.
	msg value: aValue.
	self sendMessageToClient: msg
]
