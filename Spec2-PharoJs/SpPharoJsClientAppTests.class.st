Class {
	#name : #SpPharoJsClientAppTests,
	#superclass : #TestCase,
	#category : #'Spec2-PharoJs-tests'
}

{ #category : #tests }
SpPharoJsClientAppTests >> testButton [

	| app btn actionExecuted msg window |
	app := SpPharoJsApp1 new.
	btn := app new: SpButtonPresenter.
	btn
		label: 'Click me';
		color: Color yellow;
		action: [ actionExecuted := true ].
	actionExecuted := false.
	window := btn open.
	msg := SpS2cElementClick new.
	msg elementId: btn adapter widget.
	window adapter sendMessageToClient: msg.
	20 milliseconds wait.
	self assert: actionExecuted.
	window adapter sendMessageToClient: SpS2cCloseBrowserWindow new
]

{ #category : #tests }
SpPharoJsClientAppTests >> testGetSessionAndCloseWindow [

	| session |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebSocketSession.
	self assert: session isConnected.
	session sendMessage: SpS2cCloseBrowserWindow new.
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
	session sendMessage: SpS2cCloseBrowserWindow new
]