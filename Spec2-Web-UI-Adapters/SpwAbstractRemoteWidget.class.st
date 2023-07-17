"
I keep track of the remote widget state.
I keep track of state changes.
I send messages to the client to keep the real widget in sync with my state.
I accomodate existing tests (and maybe others), that need to access widget properties directly.

"
Class {
	#name : #SpwAbstractRemoteWidget,
	#superclass : #Object,
	#instVars : [
		'id',
		'adaptor'
	],
	#category : #'Spec2-Web-UI-Adapters-Widget'
}

{ #category : #accessing }
SpwAbstractRemoteWidget >> adaptor [

	^ adaptor
]

{ #category : #accessing }
SpwAbstractRemoteWidget >> adaptor: anObject [

	adaptor := anObject
]

{ #category : #accessing }
SpwAbstractRemoteWidget >> id [

	^ id
]

{ #category : #accessing }
SpwAbstractRemoteWidget >> id: anObject [

	id := anObject
]

{ #category : #accessing }
SpwAbstractRemoteWidget >> model [
	^self adaptor model
]

{ #category : #websocket }
SpwAbstractRemoteWidget >> sendMessageToClient: msg [

	^self adaptor sendMessageToClient: msg
]
