Class {
	#name : #SpPharoJsClientAppTests,
	#superclass : #TestCase,
	#category : #'Spec2-PharoJs-client'
}

{ #category : #tests }
SpPharoJsClientAppTests >> testGetSessionAndCloseWindow [

	| session |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebsocketSession.
	session sendEnvelope: SpS2cCloseBrowserWindow new wrapInEnvelope.
	50 milliseconds wait.
	self assert: session isConnected not
]

{ #category : #tests }
SpPharoJsClientAppTests >> testSessionReconnect [

	| session |
	session := SpPharoJsClientStarter openBrowserAndAwaitWebsocketSession.
	session webSocket close.
	self halt.
	session sendEnvelope: SpS2cCloseBrowserWindow new wrapInEnvelope.
	20 milliseconds wait.
	self assert: session isConnected not
]
