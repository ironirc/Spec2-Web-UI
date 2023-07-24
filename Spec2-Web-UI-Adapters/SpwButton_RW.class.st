Class {
	#name : #'SpwButton_RW',
	#superclass : #SpwAbstractRemoteWidget,
	#category : #'Spec2-Web-UI-Adapters-RemoteWidget'
}

{ #category : #accessing }
SpwButton_RW >> icon [

	| msg envelope |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: self id.
	msg selectors: #( icon ).
	envelope := self adaptor sendMessageToClient: msg.
	^ envelope msg results first value ifNotNil: [ :spwImage |
		  SpwImageServerCache imageAtKey: spwImage cacheKey ]
]

{ #category : #accessing }
SpwButton_RW >> label [

	| msg envelope  |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: self id.
	msg selectors: #( label ).
	envelope := self adaptor sendMessageToClient: msg.
	^ envelope msg results first value
]

{ #category : #accessing }
SpwButton_RW >> label: aLabel [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: self id.
	msg properties: { ('label' -> aLabel) } asJsObject.
	self sendMessageToClient: msg
]

{ #category : #accessing }
SpwButton_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: self id.
	msg tag: SpwButton_WC tagName.
	msg events: #( click ).
	msg styles: { ('background-color'
		 -> ('#' , (self adaptor color ifNil: [ Color gray ]) asHexString)) }.

	msg attributes: { ('spw-src' -> thisContext method printString) }.
	msg properties: { ('label' -> self model label) } asJsObject.
	msg addProperty: 'icon' value: (self model icon ifNotNil: [ :frm |
			 SpwImageServerCache imageForForm: frm ]).

	msg visible: self model isVisible.
	self sendMessageToClient: msg
]
