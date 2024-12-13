Class {
	#name : 'SpwTable_RW',
	#superclass : 'SpwAbstractRemoteWidget',
	#category : 'Spec2-Web-UI-Adapters-RemoteWidget',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'RemoteWidget'
}

{ #category : 'accessing' }
SpwTable_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cCreateTabulatorTable new.
	msg elementId: self id.
	msg columns: self adaptor tabulatorColumns.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
	self model root adapter registerWidget: self
]
