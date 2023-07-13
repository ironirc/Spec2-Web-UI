Class {
	#name : #SpC2sStartSession,
	#superclass : #SpC2sMessage,
	#instVars : [
		'sessionId'
	],
	#category : #'Spec2-PharoJs-clientToServerMessages'
}

{ #category : #private }
SpC2sStartSession >> respondForRequestContext: rc [

	<pharoJsSkip>
	(SpPharoJsSessionRegistry containsSessionId: sessionId)
		ifTrue: [ SpPharoJsSessionRegistry resumeSessionId: sessionId inRequestContext: rc ]
		ifFalse: [
			SpPharoJsClientStarter
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
