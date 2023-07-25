Class {
	#name : #SpwClientAppTests,
	#superclass : #TestCase,
	#category : #'Spec2-Web-UI-tests'
}

{ #category : #tests }
SpwClientAppTests >> testButton [

	| app btn actionExecuted msg window |
	app := SpwDemoApp1 new.
	btn := app new: SpButtonPresenter.
	btn
		label: 'Click me';
		color: Color yellow;
		action: [ actionExecuted := true ].
	actionExecuted := false.
	window := btn open.
	msg := SpS2cElementClick new.
	msg elementId: btn adapter widget id.
	window adapter sendMessageToClient: msg.
	(Delay forMilliseconds: 20) wait.
	self assert: actionExecuted.
	window adapter sendMessageToClient: SpS2cCloseBrowserWindow new
]

{ #category : #tests }
SpwClientAppTests >> testGetSessionAndCloseWindow [

	| session |
	session := SpwClientStarter openBrowserAndAwaitWebSocketSession.
	self assert: session isConnected.
	session sendMessage: SpS2cCloseBrowserWindow new.
	(Delay forMilliseconds: 50) wait.
	self assert: session isConnected not.
]

{ #category : #tests }
SpwClientAppTests >> testSessionReconnect [

	| session |
	session := SpwClientStarter openBrowserAndAwaitWebSocketSession.
	session webSocket close.
	self assert: session isConnected not.
	(Delay forMilliseconds: 2500) wait.
	self assert: session isConnected.
	session sendMessage: SpS2cCloseBrowserWindow new
]
