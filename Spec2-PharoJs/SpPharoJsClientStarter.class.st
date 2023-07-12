Class {
	#name : #SpPharoJsClientStarter,
	#superclass : #Object,
	#classInstVars : [
		'pendingBrowserSessions',
		'monitor'
	],
	#category : #'Spec2-PharoJs-client'
}

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> addPendingBrowserSessionAt: id [

	| ps |
	ps := SpPharoJsPendingClientStart new.
	ps startId: id.
	self monitor critical: [ self pendingBrowserSessions add: ps ].
	self removeExpired
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> monitor [
	monitor ifNil: [ monitor := Monitor new ].
	^ monitor
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> openBrowserAndAwaitWebsocketSession [

	^ self openBrowserAndAwaitWebsocketSessionForApp:
		  SpPharoJsClientApp
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> openBrowserAndAwaitWebsocketSessionForApp: app [

	| startId m pendingSession |
	startId := UUIDGenerator next asString.
	m := self monitor.
	m critical: [
		self addPendingBrowserSessionAt: startId.
		app openBrowserWithStartId: startId.
		m
			waitWhile: [ (self pendingBrowserSessionAt: startId) isPending ]
			maxSeconds: 5.
		pendingSession := self pendingBrowserSessionAt: startId.
		pendingSession ifNotNil: [
			self pendingBrowserSessions remove: pendingSession ].
		pendingSession isPending ifTrue: [
			self error: 'failed to start or connect client app' ] ].
	pendingSession sendAcknowledgeMessage.
	^ pendingSession session
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> pendingBrowserSessionAt: startId [

	self pendingBrowserSessions do: [ :pbs |
		pbs startId = startId ifTrue: [ ^ pbs ] ].
	^ nil
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> pendingBrowserSessions [

	pendingBrowserSessions ifNil: [
		pendingBrowserSessions := OrderedCollection new ].
	^ pendingBrowserSessions
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> removeExpired [

	self monitor critical: [
		pendingBrowserSessions := pendingBrowserSessions reject: [ :e |
			                          e isExpired ] ]
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> resetSessions [
	<script>
	pendingBrowserSessions := nil
]

{ #category : #'browser session acquiring' }
SpPharoJsClientStarter class >> resolvePendingBrowserSessionAt: startId with: aRequestContext [
	self monitor critical: [
		self pendingBrowserSessions
			detect: [ :pbs | pbs startId = startId ]
			ifFound: [ :e |
				e incomingEnvelope: aRequestContext incomingEnvelope.
				e session: aRequestContext webSocketSession ].
		self monitor signal ]
]
