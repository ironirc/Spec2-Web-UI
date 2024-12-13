Class {
	#name : 'SpwMenuItem_RW',
	#superclass : 'SpwAbstractRemoteWidget',
	#category : 'Spec2-Web-UI-Adapters-RemoteWidget',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'RemoteWidget'
}

{ #category : 'accessing' }
SpwMenuItem_RW >> label [

	| msg envelope |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: self id.
	msg selectors: #( label ).
	envelope := self adaptor sendMessageToClient: msg.
	^ envelope msg results first value
]

{ #category : 'accessing' }
SpwMenuItem_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: self id.
	msg tag: (self model subMenu ifNil: [ SpwMenuItem_WC tagName] ifNotNil: [ SpwMenuItemWithSubMenu_WC  tagName]).
"	self model name ifNotNil: [:str | msg addProperty: 'label' value: str ]."
	msg properties: { ('label' -> self model name) } asJsObject.
	self model icon ifNotNil: [ :frm |
		msg
			addProperty: 'icon'
			value: (SpwImageServerCache imageForForm: frm) ].
	self sendMessageToClient: msg.
	
]
