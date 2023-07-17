Class {
	#name : #'SpwButton_RW',
	#superclass : #SpwAbstractRemoteWidget,
	#category : #'Spec2-Web-UI-Adapters-Widget'
}

{ #category : #accessing }
SpwButton_RW >> label [

	| msg envelope  |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: self id.
	msg selectors: #( textContent ).
	envelope := self adaptor sendMessageToClient: msg.
	^ envelope msg results first value
]

{ #category : #accessing }
SpwButton_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: self id.
	msg tag: SpwButton_WC tagName.
	msg textContent: self adaptor label.
	msg events: #( click ).
	msg styles: { ('background-color'
		 -> ('#' , (self adaptor color ifNil: [ Color gray ]) asHexString)) }.
	msg attributes: { ('spw-src' -> thisContext method printString) }.
	self sendMessageToClient: msg
]
