Class {
	#name : #'SpwTable_RW',
	#superclass : #SpwAbstractRemoteWidget,
	#category : #'Spec2-Web-UI-Adapters-RemoteWidget'
}

{ #category : #accessing }
SpwTable_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cCreateTabulatorTable new.
	msg elementId: self id.
	msg columns: self adaptor tabulatorColumns.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
]
