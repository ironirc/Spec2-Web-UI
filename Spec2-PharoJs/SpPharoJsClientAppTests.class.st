Class {
	#name : #SpPharoJsClientAppTests,
	#superclass : #TestCase,
	#category : #'Spec2-PharoJs-tests'
}

{ #category : #tests }
SpPharoJsClientAppTests >> testButton [

	| session app btn actionExecuted msg |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebSocketSession.
	app := SpPharoJsApp1 new.
	btn := app new: SpButtonPresenter.
	btn
		label: 'Click me';
		color: Color yellow;
		action: [ actionExecuted := true ].
	actionExecuted := false.
	CurrentWebSocketSession value: session during: [ btn open ].
	msg := SpS2cElementClick new.
	msg elementId: btn adapter widget.
	session sendEnvelope: msg wrapInEnvelope.
	20 milliseconds wait.
	self assert: actionExecuted.
	session sendEnvelope: SpS2cCloseBrowserWindow new wrapInEnvelope.
	50 milliseconds wait.
	self assert: session isConnected not
]

{ #category : #tests }
SpPharoJsClientAppTests >> testGetSessionAndCloseWindow [

	| session |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebSocketSession.
	self assert: session isConnected.
	session sendEnvelope: SpS2cCloseBrowserWindow new wrapInEnvelope.
	50 milliseconds wait.
	self assert: session isConnected not.
]

{ #category : #tests }
SpPharoJsClientAppTests >> testSessionReconnect [

	| session |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebSocketSession.
	session webSocket close.
	self assert: session isConnected not.
	2500 milliseconds wait.
	self assert: session isConnected.
	session sendEnvelope: SpS2cCloseBrowserWindow new wrapInEnvelope
]
