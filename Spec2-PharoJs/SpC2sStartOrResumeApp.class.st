Class {
	#name : #SpC2sStartOrResumeApp,
	#superclass : #SpC2sMessage,
	#instVars : [
		'windowId',
		'sessionId',
		'clientId'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpC2sStartOrResumeApp >> clientId [

	^ clientId
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> clientId: anObject [

	clientId := anObject
]

{ #category : #private }
SpC2sStartOrResumeApp >> respondForRequestContext: rc [

	<pharoJsSkip>
	| sessionRegistry app |
	sessionRegistry := rc handler context.
	app := sessionRegistry appForClientId: clientId sessionId: sessionId.
	app context: rc webSocketInfo. "adaptors need it to be able to send messages to client"
	rc webSocketInfo propertyAt: 'app' put: app.
	app startWindowId: windowId
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> sessionId [

	^ sessionId
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> sessionId: anObject [

	sessionId := anObject
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> windowId [

	^ windowId
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> windowId: anObject [

	windowId := anObject
]
