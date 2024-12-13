Class {
	#name : 'SpwMenu_A',
	#superclass : 'SpwBaseMenu_A',
	#category : 'Spec2-Web-UI-Adapters-Adaptors',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'Adaptors'
}

{ #category : 'accessing' }
SpwMenu_A class >> remoteWidgetClass [ 

	^SpwMenu_RW
]

{ #category : 'events' }
SpwMenu_A >> handleItemselect: e [

	self model menuGroups do: [ :mg |
		mg menuItems do: [ :mi |
			mi adapter widget id = e itemId ifTrue: [
				mi subMenu ifNotNil: [self launchSubMenuOnMenuItem: mi] ifNil: [ mi action value ] ] ] ]
]

{ #category : 'events' }
SpwMenu_A >> launchSubMenuOnMenuItem: mi [

	| subMenuWidget msg |
	subMenuWidget := mi subMenu build.
	msg := SpS2cShowSubMenuOnMenuItem new.
	msg elementId: subMenuWidget id.
	msg targetId: mi adapter widget id.
	self sendMessageToClient: msg
]
