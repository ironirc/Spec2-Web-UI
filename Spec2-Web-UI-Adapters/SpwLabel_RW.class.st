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
