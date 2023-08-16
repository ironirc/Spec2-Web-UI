Class {
	#name : #'SpwMenu_RW',
	#superclass : #SpwAbstractRemoteWidget,
	#category : #'Spec2-Web-UI-Adapters-RemoteWidget'
}

{ #category : #accessing }
SpwMenu_RW >> label [

	| msg envelope |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: self id.
	msg selectors: #( label ).
	envelope := self adaptor sendMessageToClient: msg.
	^ envelope msg results first value
]

{ #category : #accessing }
SpwMenu_RW >> sendCreateMessage [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: self id.
	msg tag: SpwMenu_WC tagName.
	msg events: #( itemselect ).

	"msg properties: { ('title' -> self model title) } asJsObject."
	self sendMessageToClient: msg.
	self model menuGroups
		do: [ :eachGroup |
			eachGroup menuItems do: [ :each |
				| menuItemWidget msg2 |
				menuItemWidget := each build.
				msg2 := SpS2cAddElementToParent new.
				msg2 elementId: menuItemWidget id.
				msg2 parentId: self id.
				self sendMessageToClient: msg2 ] ]
		separatedBy: [ "gtkWidget add: (GtkSeparatorMenuItem new
				show;
				yourself)"
			self halt ].
	self model root adapter registerWidget: self
]
