Class {
	#name : 'SpS2cMessageWithElementId',
	#superclass : 'SpS2cMessage',
	#instVars : [
		'elementId',
		'events'
	],
	#category : 'Spec2-Web-UI-serverToClientMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'serverToClientMessages'
}

{ #category : 'private' }
SpS2cMessageWithElementId >> createElement [

	| el |
	el := self document createElement: self tag.
	el setAttribute: 'id' value: elementId.
	self nodeCache nodeAt: elementId put: el. 
	console log: 'created element:' with: el. 
	^ el
]

{ #category : 'private' }
SpS2cMessageWithElementId >> createElementAndAddEventListenersIn: rc [

	| el |
	el := self createElement.
	self initializeNewElement: el in: rc.
	^ el
]

{ #category : 'accessing' }
SpS2cMessageWithElementId >> element [

	^ self getElementById: elementId
]

{ #category : 'accessing' }
SpS2cMessageWithElementId >> elementId [

	^ elementId
]

{ #category : 'accessing' }
SpS2cMessageWithElementId >> elementId: anObject [

	elementId := anObject
]

{ #category : 'private' }
SpS2cMessageWithElementId >> ensuredElementIn: rc [

	^ self element ifNil: [ self createElementAndAddEventListenersIn: rc ]
]

{ #category : 'accessing' }
SpS2cMessageWithElementId >> events [

	^ events
]

{ #category : 'accessing' }
SpS2cMessageWithElementId >> events: anObject [

	events := anObject
]

{ #category : 'accessing' }
SpS2cMessageWithElementId >> getElementById: anId [

	^ (self document getElementById: anId) ifNil: [
		  self nodeCache nodeOrNilAt: anId ]
]

{ #category : 'private' }
SpS2cMessageWithElementId >> initializeNewElement: el in: rc [

	events do: [ :eventName | 
		| cls |
		cls := SpC2sWidgetEvent forEventName: eventName.
		el addEventListener: eventName block: [ :nativeEvent | 
			| msg |
			nativeEvent preventDefault.
			msg := cls newForNativeEvent: nativeEvent.
			msg sourceId: elementId.
			rc wsHandler sendMessageToServer: msg.  ] ]
]

{ #category : 'private' }
SpS2cMessageWithElementId >> nodeCache [

	^ SpwClientApp current
]
