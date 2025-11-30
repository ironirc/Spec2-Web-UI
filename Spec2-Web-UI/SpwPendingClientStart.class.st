Class {
	#name : 'SpwPendingClientStart',
	#superclass : 'Object',
	#instVars : [
		'startId',
		'session',
		'incomingEnvelope',
		'startedAt'
	],
	#category : 'Spec2-Web-UI-server-support',
	#package : 'Spec2-Web-UI',
	#tag : 'server-support'
}

{ #category : 'accessing' }
SpwPendingClientStart >> incomingEnvelope [

	^ incomingEnvelope
]

{ #category : 'accessing' }
SpwPendingClientStart >> incomingEnvelope: anObject [

	incomingEnvelope := anObject
]

{ #category : 'initialize-release' }
SpwPendingClientStart >> initialize [

	super initialize.
	startedAt := DateAndTime now
]

{ #category : 'testing' }
SpwPendingClientStart >> isExpired [

	startedAt ifNil: [ ^ true ].
	^ DateAndTime now - startedAt > (Duration milliSeconds: 5000 )
]

{ #category : 'testing' }
SpwPendingClientStart >> isPending [ 

	^session isNil
]

{ #category : 'private' }
SpwPendingClientStart >> sendAcknowledgeMessage [

	| msg |
	SpwSessionRegistry registerSession: session at: startId.
	msg := PhxSpaResponse new.
	msg type: #success.
	msg message: 'session successfully started'.
	self session
		sendMessage: msg
		isResponseToIncoming: self incomingEnvelope
]

{ #category : 'accessing' }
SpwPendingClientStart >> session [

	^ session
]

{ #category : 'accessing' }
SpwPendingClientStart >> session: anObject [

	session := anObject
]

{ #category : 'accessing' }
SpwPendingClientStart >> startId [

	^ startId
]

{ #category : 'accessing' }
SpwPendingClientStart >> startId: anObject [

	startId := anObject
]

{ #category : 'accessing' }
SpwPendingClientStart >> startedAt [

	^ startedAt
]

{ #category : 'accessing' }
SpwPendingClientStart >> startedAt: anObject [

	startedAt := anObject
]
