Class {
	#name : #SpPharoJsPendingClientStart,
	#superclass : #Object,
	#instVars : [
		'startId',
		'session',
		'incomingEnvelope',
		'startedAt'
	],
	#category : #'Spec2-PharoJs-client'
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
	^ DateAndTime now - startedAt > 5000 milliseconds
]

{ #category : #testing }
SpPharoJsPendingClientStart >> isPending [ 

	^session isNil
]

{ #category : #private }
SpPharoJsPendingClientStart >> sendAcknowledgeMessage [

	self session
		sendMessage: SpS2cSimpleResponse new
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
