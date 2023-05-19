Class {
	#name : #SpC2sStartApp,
	#superclass : #SpC2sMessage,
	#category : #'Spec2-PharoJs'
}

{ #category : #private }
SpC2sStartApp >> respondForRequestContext: rc [

	<pharoJsSkip>
	| clientId sessionRegistry app |
	clientId := rc incomingEnvelope senderId.
	sessionRegistry := rc handler context.
	app := sessionRegistry appAtClientId: clientId ifAbsentPut: [ 
		       | newApp |
		       newApp := SpPharoJsApp1 new.
		       newApp useBackend: #PharoJs.
		       newApp ].
	app context: rc webSocketInfo.
	rc webSocketInfo propertyAt: 'app' put: app.
	app start
]
