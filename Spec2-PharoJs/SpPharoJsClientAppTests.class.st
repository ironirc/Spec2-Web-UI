Class {
	#name : #SpPharoJsClientAppTests,
	#superclass : #TestCase,
	#category : #'Spec2-PharoJs-tests'
}

{ #category : #tests }
SpPharoJsClientAppTests >> testGetSessionAndCloseWindow [

	| session |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebsocketSession.
	self assert: session isConnected.
	session sendEnvelope: SpS2cCloseBrowserWindow new wrapInEnvelope.
	50 milliseconds wait.
	self assert: session isConnected not.
]

{ #category : #tests }
SpPharoJsClientAppTests >> testSessionReconnect [

	| session |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebsocketSession.
	session webSocket close.
	3500 milliseconds wait.
	self assert: session isConnected.
	session sendEnvelope: SpS2cCloseBrowserWindow new wrapInEnvelope
]
