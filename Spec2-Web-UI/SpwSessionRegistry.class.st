Class {
	#name : #SpwSessionRegistry,
	#superclass : #Object,
	#classVars : [
		'sessions'
	],
	#classInstVars : [
		'dict',
		'session'
	],
	#category : #'Spec2-Web-UI-server-support'
}

{ #category : #accessing }
SpwSessionRegistry class >> containsSessionId: id [

	^ self sessions keys includes: id
]

{ #category : #accessing }
SpwSessionRegistry class >> registerSession: session at: id [

	self sessions at: id put: session.
]

{ #category : #accessing }
SpwSessionRegistry class >> reset [
	<script>
	sessions := nil
]

{ #category : #accessing }
SpwSessionRegistry class >> resumeSessionId: sessionId inRequestContext: rc [

	| oldSession   |
	oldSession := self sessionAt: sessionId.
	oldSession isConnected ifTrue: [
		self error: 'the session to be resumed is still connected' ].
	rc handler replaceOldWebSocket: oldSession webSocket with: rc webSocket.
	rc sendSuccess: 'session successfully resumed'
]

{ #category : #accessing }
SpwSessionRegistry class >> sessionAt: id [

	^ self sessions
		  at: id
		  ifAbsent: [ self error: 'no session found for given id' ]
]

{ #category : #accessing }
SpwSessionRegistry class >> sessions [
	sessions ifNil: [ sessions := Dictionary new ].
	^ sessions
]
