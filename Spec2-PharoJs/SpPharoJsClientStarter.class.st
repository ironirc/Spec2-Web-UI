Class {
	#name : #SpPharoJsClientStarter,
	#superclass : #Object,
	#classInstVars : [
		'pendingBrowserSessions',
		'monitor'
	],
	#category : #'Spec2-PharoJs-client'
}

{ #category : #private }
SpPharoJsClientStarter class >> addPendingBrowserSessionAt: aStartId [

	| ps |
	ps := SpPharoJsPendingClientStart new.
	ps startId: aStartId.
	self pendingBrowserSessions add: ps.
	"take opportunity to clean up expired pending sessions"
	self removeExpiredSessions
]

{ #category : #private }
SpPharoJsClientStarter class >> monitor [
	monitor ifNil: [ monitor := Monitor new ].
	^ monitor
]

{ #category : #public }
SpPharoJsClientStarter class >> openBrowserAndAwaitWebsocketSession [

	^ self openBrowserAndAwaitWebsocketSessionForApp:
		  SpPharoJsClientApp
]

{ #category : #private }
SpPharoJsClientStarter class >> openBrowserAndAwaitWebsocketSessionForApp: app [

	| startId m pbs |
	startId := UUIDGenerator next asString.
	m := self monitor.
	m critical: [
		self addPendingBrowserSessionAt: startId.
		app openBrowserWithStartId: startId.
		m
			waitWhile: [ (self pendingBrowserSessionAt: startId) isPending ]
			maxSeconds: 5.
		pbs := self pendingBrowserSessionAt: startId.
		(pbs isNil or: [ pbs isPending ]) ifTrue: [
			self error: 'failed to start or connect client app' ].
		pbs ifNotNil: [ self pendingBrowserSessions remove: pbs ] ].
	pbs sendAcknowledgeMessage.
	^ pbs session
]

{ #category : #private }
SpPharoJsClientStarter class >> pendingBrowserSessionAt: aStartId [

	self pendingBrowserSessions do: [ :pbs |
		pbs startId = aStartId ifTrue: [ ^ pbs ] ].
	self error: 'there''s no pending session for given id'
]

{ #category : #private }
SpPharoJsClientStarter class >> pendingBrowserSessions [

	pendingBrowserSessions ifNil: [
		pendingBrowserSessions := OrderedCollection new ].
	^ pendingBrowserSessions
]

{ #category : #private }
SpPharoJsClientStarter class >> removeExpiredSessions [

	pendingBrowserSessions := pendingBrowserSessions reject: [ :e |
		                          e isExpired ]
]

{ #category : #public }
SpPharoJsClientStarter class >> resetSessions [
	"Should not be needed. Might be usefull during development"
	<script>
	pendingBrowserSessions := nil
]

{ #category : #private }
SpPharoJsClientStarter class >> resolvePendingBrowserSessionAt: startId with: aRequestContext [
	self monitor critical: [
		self pendingBrowserSessions
			detect: [ :pbs | pbs startId = startId ]
			ifFound: [ :e |
				e incomingEnvelope: aRequestContext incomingEnvelope.
				e session: aRequestContext webSocketSession ]
			ifNone: [self error: 'no pending session found for given id'].
		self monitor signal.
		self removeExpiredSessions ]
]
