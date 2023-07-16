Class {
	#name : #SpwClientStarter,
	#superclass : #Object,
	#classInstVars : [
		'pendingBrowserSessions',
		'monitor'
	],
	#category : #'Spec2-Web-UI-client'
}

{ #category : #private }
SpwClientStarter class >> addPendingBrowserSessionAt: aStartId [

	| ps |
	ps := SpwPendingClientStart new.
	ps startId: aStartId.
	self pendingBrowserSessions add: ps.
	"take opportunity to clean up expired pending sessions"
	self removeExpiredSessions
]

{ #category : #private }
SpwClientStarter class >> monitor [
	monitor ifNil: [ monitor := Monitor new ].
	^ monitor
]

{ #category : #public }
SpwClientStarter class >> openBrowserAndAwaitWebSocketSession [

	^ self openBrowserAndAwaitWebsocketSessionForApp:
		  SpwClientApp
]

{ #category : #private }
SpwClientStarter class >> openBrowserAndAwaitWebsocketSessionForApp: app [

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
SpwClientStarter class >> pendingBrowserSessionAt: aStartId [

	self pendingBrowserSessions do: [ :pbs |
		pbs startId = aStartId ifTrue: [ ^ pbs ] ].
	self error: 'there''s no pending session for given id'
]

{ #category : #private }
SpwClientStarter class >> pendingBrowserSessions [

	pendingBrowserSessions ifNil: [
		pendingBrowserSessions := OrderedCollection new ].
	^ pendingBrowserSessions
]

{ #category : #private }
SpwClientStarter class >> removeExpiredSessions [

	pendingBrowserSessions := pendingBrowserSessions reject: [ :e |
		                          e isExpired ]
]

{ #category : #public }
SpwClientStarter class >> resetSessions [
	"Should not be needed. Might be usefull during development"
	<script>
	pendingBrowserSessions := nil
]

{ #category : #private }
SpwClientStarter class >> resolvePendingBrowserSessionAt: startId inRequestContext: aRequestContext [
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
