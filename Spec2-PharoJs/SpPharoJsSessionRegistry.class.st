Class {
	#name : #SpPharoJsSessionRegistry,
	#superclass : #Object,
	#classVars : [
		'sessions'
	],
	#classInstVars : [
		'dict',
		'session'
	],
	#category : #'Spec2-PharoJs-server-support'
}

{ #category : #accessing }
SpPharoJsSessionRegistry class >> containsSessionId: id [

	^ self sessions keys includes: id
]

{ #category : #obsolete }
SpPharoJsSessionRegistry class >> ensureValidExistingOrNewSessionForClientId: clientId sessionId: sessionId [

	| newApp newSessionId |
	sessionId ifNotNil: [ 
	self sessions
		at: clientId , sessionId
		ifPresent: [ :app | "TODO: check if app instance is still ok" ^ sessionId ]].
	newSessionId := UUIDGenerator next asString.
	newApp := SpPharoJsApp1 new.
	newApp useBackend: #PharoJs.
	self sessions at: clientId , newSessionId put: newApp.
	^ newSessionId
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> registerSession: session at: id [

	self sessions at: id put: session.
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> reset [
	<script>
	sessions := nil
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> resumeSessionId: sessionId inRequestContext: rc [

	| oldSession   |
	oldSession := self sessionAt: sessionId.
	oldSession isConnected ifTrue: [
		self error: 'the session to be resumed is still connected' ].
	rc handler replaceOldWebSocket: oldSession webSocket with: rc webSocket.
	rc sendSuccess: 'session successfully resumed'
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> sessionAt: id [

	^ self sessions
		  at: id
		  ifAbsent: [ self error: 'no session found for given id' ]
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> sessions [
	sessions ifNil: [ sessions := Dictionary new ].
	^ sessions
]
