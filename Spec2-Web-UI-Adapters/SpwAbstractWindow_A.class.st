Class {
	#name : #'SpwAbstractWindow_A',
	#superclass : #SpwAbstractAdapter,
	#instVars : [
		'toolbarMorph',
		'menuMorph',
		'webSocketSession'
	],
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #testing }
SpwAbstractWindow_A class >> isAbstract [ 

	^self == SpwAbstractWindow_A
]

{ #category : #private }
SpwAbstractWindow_A >> adapt: aPresenter [

	self webSocketSession ifNil: [self openNewBrowserWindow].
	super adapt: aPresenter
]

{ #category : #private }
SpwAbstractWindow_A >> add: containerMorph toWindow: aSpecWindow [

	"aSpecWindow 
		addMorph: containerMorph 
		fullFrame: LayoutFrame identity"
		
		| msg |
	msg := SpS2cAddElementToParent new.
	msg elementId: containerMorph id.
	msg parentId: aSpecWindow id.
	self sendMessageToClient: msg.
]

{ #category : #private }
SpwAbstractWindow_A >> addContent: aMorph toWindow: aSpecWindow [
	| containerMorph msg |
	
	containerMorph := self newContainerMorph.
	"containerMorph layoutFrame: aMorph layoutFrame."

	"add all decorations (menu, toolbar and statusbar)"
	self model hasMenu ifTrue: [ self addMenuTo: containerMorph ].

	self setToolbarTo: containerMorph.

	"Register for changes in the toolbar"
	self model whenToolbarChangedDo: [ self setToolbarTo: containerMorph ].

	msg := SpS2cAddElementToParent new.
	msg elementId: aMorph id.
	msg parentId: containerMorph id.
	self sendMessageToClient: msg.

	"containerMorph addMorphBack: aMorph." "containerMorph children add: aMorph."
"	aMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	self model hasStatusBar ifTrue: [ self addStatusBarTo: containerMorph ]."
	
	self add: containerMorph toWindow: aSpecWindow
	"aSpecWindow children add: containerMorph"
]

{ #category : #private }
SpwAbstractWindow_A >> addMenuTo: aMorph [
	
	menuMorph := self model menu build.
	aMorph addMorphBack: menuMorph.	
	menuMorph
		hResizing: #spaceFill;
		vResizing: #rigid
]

{ #category : #private }
SpwAbstractWindow_A >> addStatusBarTo: aMorph [

	| statusBarMorph |
	statusBarMorph := self model statusBar build.
	aMorph addMorphBack: statusBarMorph.
	statusBarMorph
		hResizing: #spaceFill;
		vResizing: #rigid
]

{ #category : #private }
SpwAbstractWindow_A >> newContainerMorph [

	"	^ Morph new
		color: Color transparent;
		layoutPolicy: TableLayout new;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		listDirection: #topToBottom;
		yourself"

	| rw msg |
	rw := self newRemoteWidget.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: rw id.
	msg tag: 'div'.
	msg styles: { 
			('background-color' -> '#EEE').
			('height' -> '100vh').
			"('display' -> 'flex')" }.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
	^ rw
]

{ #category : #private }
SpwAbstractWindow_A >> openNewBrowserWindow [

	CurrentWebSocketSession value:
		SpwClientStarter openBrowserAndAwaitWebSocketSession.
	CurrentWebSocketSession value propertyAt: 'windowAdaptor' put: self.
	self webSocketSession: CurrentWebSocketSession value
]

{ #category : #private }
SpwAbstractWindow_A >> setToolbarTo: aMorph [
	| newToolbarMorph toolbarPresenter |
	
	self model hasToolbar 
		ifFalse: [
			toolbarMorph ifNotNil: [ 
				aMorph removeMorph: toolbarMorph.
				toolbarMorph := nil.  ].
			^ self ].
	
	toolbarPresenter := self presenter toolbar.
	newToolbarMorph := toolbarPresenter build.
	toolbarPresenter adapter applyStyle.
	newToolbarMorph
		hResizing: #spaceFill;
		vResizing: #rigid.
	
	"If we have a toolbar morph, we replace with the new one"
	toolbarMorph 
		ifNotNil: [ aMorph replaceSubmorph: toolbarMorph by: newToolbarMorph ]
		ifNil: [	
			menuMorph 
				ifNotNil: [ aMorph addMorph: newToolbarMorph after: menuMorph ]
				ifNil: [ aMorph addMorph: newToolbarMorph ] ].
		
	toolbarMorph := newToolbarMorph

]

{ #category : #accessing }
SpwAbstractWindow_A >> webSocketSession [

	^webSocketSession
]

{ #category : #accessing }
SpwAbstractWindow_A >> webSocketSession: anObject [

	webSocketSession := anObject
]
