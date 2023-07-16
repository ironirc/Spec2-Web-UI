Class {
	#name : #SpC2sStartSession,
	#superclass : #SpC2sMessage,
	#instVars : [
		'sessionId'
	],
	#category : #'Spec2-Web-UI-clientToServerMessages'
}

{ #category : #private }
SpC2sStartSession >> respondForRequestContext: rc [

	<pharoJsSkip>
	(SpwSessionRegistry containsSessionId: sessionId)
		ifTrue: [ SpwSessionRegistry resumeSessionId: sessionId inRequestContext: rc ]
		ifFalse: [
			SpwClientStarter
				resolvePendingBrowserSessionAt: self sessionId
				inRequestContext: rc ]
]

{ #category : #accessing }
SpC2sStartSession >> sessionId [

	^ sessionId
]

{ #category : #accessing }
SpC2sStartSession >> sessionId: anObject [

	sessionId := anObject
]
