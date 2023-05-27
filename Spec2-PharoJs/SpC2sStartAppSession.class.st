Class {
	#name : #SpC2sStartAppSession,
	#superclass : #SpC2sMessage,
	#instVars : [
		'clientId',
		'sessionId'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpC2sStartAppSession >> clientId [

	^ clientId
]

{ #category : #accessing }
SpC2sStartAppSession >> clientId: anObject [

	clientId := anObject
]

{ #category : #private }
SpC2sStartAppSession >> respondForRequestContext: rc [

	"The client needs a session (id) to start with"

	<pharoJsSkip>
	| sessionRegistry ensuredSessionId msg |
	sessionRegistry := rc handler context.
	ensuredSessionId := sessionRegistry
		                    ensureValidExistingOrNewSessionForClientId:
		                    clientId
		                    sessionId: sessionId.
	msg := SpS2cSimpleResponse new.
	msg payload: ensuredSessionId.
	rc sendResponseMessage: msg
]

{ #category : #accessing }
SpC2sStartAppSession >> sessionId [

	^ sessionId
]

{ #category : #accessing }
SpC2sStartAppSession >> sessionId: anObject [

	sessionId := anObject
]
