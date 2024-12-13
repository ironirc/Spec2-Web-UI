Class {
	#name : 'SpwLabel_RW',
	#superclass : 'SpwAbstractRemoteWidget',
	#category : 'Spec2-Web-UI-Adapters-RemoteWidget',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'RemoteWidget'
}

{ #category : 'accessing' }
SpwLabel_RW >> label [

	| msg envelope |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: self id.
	msg selectors: #( label ).
	envelope := self adaptor sendMessageToClient: msg.
	^ envelope msg results first value
]

{ #category : 'accessing' }
SpwLabel_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: self id.
	msg tag: SpwLabel_WC tagName.
	msg properties: { ('label' -> self model label) } asJsObject.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
]
