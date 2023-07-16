Class {
	#name : #SpPharoJsPendingClientStart,
	#superclass : #Object,
	#instVars : [
		'startId',
		'session',
		'incomingEnvelope',
		'startedAt'
	],
	#category : #'Spec2-PharoJs-server-support'
}

{ #category : #accessing }
SpPharoJsPendingClientStart >> incomingEnvelope [

	^ incomingEnvelope
]

{ #category : #accessing }
SpPharoJsPendingClientStart >> incomingEnvelope: anObject [

	incomingEnvelope := anObject
]

{ #category : #'initialize-release' }
SpPharoJsPendingClientStart >> initialize [

	super initialize.
	startedAt := DateAndTime now
]

{ #category : #testing }
SpPharoJsPendingClientStart >> isExpired [

	startedAt ifNil: [ ^ true ].
	^ DateAndTime now - startedAt > (Duration milliSeconds: 5000 )
]

{ #category : #testing }
SpPharoJsPendingClientStart >> isPending [ 

	^session isNil
]

{ #category : #private }
SpPharoJsPendingClientStart >> sendAcknowledgeMessage [

	| msg |
	SpPharoJsSessionRegistry registerSession: session at: startId.
	msg := PhxSpaResponse new.
	msg type: #success.
	msg message: 'session successfully started'.
	self session
		sendMessage: msg
		isResponseToIncoming: self incomingEnvelope
]

{ #category : #accessing }
SpPharoJsPendingClientStart >> session [

	^ session
]

{ #category : #accessing }
SpPharoJsPendingClientStart >> session: anObject [

	session := anObject
]

{ #category : #accessing }
SpPharoJsPendingClientStart >> startId [

	^ startId
]

{ #category : #accessing }
SpPharoJsPendingClientStart >> startId: anObject [

	startId := anObject
]

{ #category : #accessing }
SpPharoJsPendingClientStart >> startedAt [

	^ startedAt
]

{ #category : #accessing }
SpPharoJsPendingClientStart >> startedAt: anObject [

	startedAt := anObject
]
