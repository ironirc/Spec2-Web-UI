Class {
	#name : #SpC2sStartSessionApp,
	#superclass : #SpC2sMessage,
	#instVars : [
		'windowId',
		'sessionId',
		'clientId',
		'urlSessionId'
	],
	#category : #'Spec2-PharoJs-clientToServerMessages'
}

{ #category : #accessing }
SpC2sStartSessionApp >> clientId [

	^ clientId
]

{ #category : #accessing }
SpC2sStartSessionApp >> clientId: anObject [

	clientId := anObject
]

{ #category : #private }
SpC2sStartSessionApp >> respondForRequestContext: rc [

	<pharoJsSkip>
	'SpC2sStartOrResumeApp>>#respondForRequestContext:' crTrace.
	SpPharoJsClientStarter
		resolvePendingBrowserSessionAt: self urlSessionId
		with: rc
]

{ #category : #accessing }
SpC2sStartSessionApp >> sessionId [

	^ sessionId
]

{ #category : #accessing }
SpC2sStartSessionApp >> sessionId: anObject [

	sessionId := anObject
]

{ #category : #accessing }
SpC2sStartSessionApp >> urlSessionId [

	^ urlSessionId
]

{ #category : #accessing }
SpC2sStartSessionApp >> urlSessionId: anObject [

	urlSessionId := anObject
]

{ #category : #accessing }
SpC2sStartSessionApp >> windowId [

	^ windowId
]

{ #category : #accessing }
SpC2sStartSessionApp >> windowId: anObject [

	windowId := anObject
]
