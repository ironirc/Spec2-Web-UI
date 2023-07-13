Class {
	#name : #'SpC2sStartAppSession_Obsolete',
	#superclass : #SpC2sMessage,
	#instVars : [
		'clientId',
		'sessionId'
	],
	#category : #'Spec2-PharoJs-clientToServerMessages'
}

{ #category : #accessing }
SpC2sStartAppSession_Obsolete >> clientId [

	^ clientId
]

{ #category : #accessing }
SpC2sStartAppSession_Obsolete >> clientId: anObject [

	clientId := anObject
]

{ #category : #private }
SpC2sStartAppSession_Obsolete >> respondForRequestContext: rc [

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
SpC2sStartAppSession_Obsolete >> sessionId [

	^ sessionId
]

{ #category : #accessing }
SpC2sStartAppSession_Obsolete >> sessionId: anObject [

	sessionId := anObject
]
