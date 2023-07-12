Class {
	#name : #SpC2sStartOrResumeApp,
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
SpC2sStartOrResumeApp >> clientId [

	^ clientId
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> clientId: anObject [

	clientId := anObject
]

{ #category : #private }
SpC2sStartOrResumeApp >> respondForRequestContext: rc [
	"	| sessionRegistry app |
	sessionRegistry := rc handler context.
	app := sessionRegistry appForClientId: clientId sessionId: sessionId.
	app context: rc webSocketSession. ""adaptors need it to be able to send messages to client""
	rc webSocketSession propertyAt: 'app' put: app.
	app windows
		detect: [ :win | win adapter windowId = windowId ]
		ifFound: [ :win | 
			self halt. 
			^ win open ]
		ifNone: [ self error: 'no window found with this id' ]"

	<pharoJsSkip>
	'SpC2sStartOrResumeApp>>#respondForRequestContext:' crTrace.
	SpPharoJsClientStarter 
		resolvePendingBrowserSessionAt: self urlSessionId
		with: rc.
		
	"msg := SpS2cSimpleResponse new.
	rc sendResponseMessage: msg"
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
SpC2sStartOrResumeApp >> urlSessionId [

	^ urlSessionId
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> urlSessionId: anObject [

	urlSessionId := anObject
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> windowId [

	^ windowId
]

{ #category : #accessing }
SpC2sStartOrResumeApp >> windowId: anObject [

	windowId := anObject
]
