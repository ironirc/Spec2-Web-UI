Class {
	#name : #'SpwLabel_RW',
	#superclass : #SpwAbstractRemoteWidget,
	#category : #'Spec2-Web-UI-Adapters-Widget'
}

{ #category : #accessing }
SpwLabel_RW >> contents [

	| msg envelope |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: self id.
	msg selectors: #( textContent ).
	envelope := self adaptor sendMessageToClient: msg.
	^ envelope msg results first value
]

{ #category : #accessing }
SpwLabel_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: self id.
	msg tag: SpwLabel_WC tagName.
	msg textContent: self adaptor getText asString.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
]
