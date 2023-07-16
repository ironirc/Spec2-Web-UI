Class {
	#name : #'SpwWindow_A',
	#superclass : #'SpwAbstractWindow_A',
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #'widget API' }
SpwWindow_A >> aboutTitle [
    ^ self model model
         ifNotNil: [ :m | (m respondsTo: #aboutTitle)
		ifTrue: [m aboutTitle]
		ifFalse: [m class name]].
]

{ #category : #initialization }
SpwWindow_A >> addFocusRotationKeyBindings [
	"Windows should not process keybindings (because then the active widget will not get 
	 the event)"
]

{ #category : #protocol }
SpwWindow_A >> addPresenterIn: aWindow withSpecLayout: aSpec [

	| contentWidget |
"	self presenter initialPosition ifNotNil: [ :position | 
		aWindow position: position ].
	self presenter initialExtent ifNotNil: [ :extent | 
		aWindow extent: extent ].
	self presenter hasDecorations ifFalse: [ aWindow removeLabelArea ].
	self presenter whenDecorationsChangedDo: [ :aBoolean | 
		aBoolean
			ifTrue: [ aWindow initializeLabelArea ]
			ifFalse: [ aWindow removeLabelArea ] ].
	self presenter whenResizableChangedDo: [ :aBoolean | 
		aWindow isResizeable: aBoolean ]."

	contentWidget := self presenter presenter buildWithLayout: aSpec.
	self presenter presenter adapter applyStyle.
	self addContent: contentWidget toWindow: aWindow
]

{ #category : #'widget API' }
SpwWindow_A >> askOkToClose [

	^ self model askOkToClose
]

{ #category : #protocol }
SpwWindow_A >> beep [ 
	
	widget flash
]

{ #category : #factory }
SpwWindow_A >> buildWidget [
	"^ SpWindow new  <- MORPHIC stuff !!!
		model: model;
		isResizeable: self isResizable;
		in: [ :this | self subscribeToAnnouncements: this ];
		yourself"

	| rw msg |
	rw := self newRemoteWidget.
	rw id: 'body'.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: rw id.
	msg tag: 'div'.
	msg styles: { ('background-color' -> '#EEE') }.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
	^ rw
]

{ #category : #'widget API' }
SpwWindow_A >> cancelled [

	^ false
]

{ #category : #protocol }
SpwWindow_A >> centered [

	self widgetDo: [ :w | 
		w
			computeFullBounds;
			position: (self currentWorld extent - w extent) // 2 ]
]

{ #category : #'widget API' }
SpwWindow_A >> centeredRelativeTo: aWindowPresenter [
	| bounds position |

	self widgetDo: [ :w | 
		w computeFullBounds.
		bounds := aWindowPresenter
			ifNotNil: [ aWindowPresenter adapter widget bounds ]
			ifNil: [ self currentWorld bounds ].
		position := bounds origin + ((bounds extent - w extent) // 2).
		w position: position ]
]

{ #category : #protocol }
SpwWindow_A >> close [

	"self widget ifNotNil: [ :w | w close ]"
]

{ #category : #'widget API' }
SpwWindow_A >> delete [

	self widgetDo: [ :w | 
		self sendMessageToClient: SpS2cCloseBrowserWindow new.
		self application windowClosed: self ]
]

{ #category : #protocol }
SpwWindow_A >> extent: aPoint [

	^ self widget extent: aPoint
]

{ #category : #'widget API' }
SpwWindow_A >> initialExtent [

	^ self model initialExtent
]

{ #category : #'event installing' }
SpwWindow_A >> installFocusLostEvent: anEvent to: aWidget [

	aWidget announcer
		when: WindowDeActivated
		do: [ anEvent action value ]
]

{ #category : #'event installing' }
SpwWindow_A >> installFocusReceivedEvent: anEvent to: aWidget [

	aWidget announcer
		when: WindowActivated
		do: [ anEvent action value ]
]

{ #category : #protocol }
SpwWindow_A >> isDisplayed [

	^ self widget isDisplayed
]

{ #category : #'widget API' }
SpwWindow_A >> isMaximized [

	self widgetDo: [ :w | ^ w isMaximized ].
	^ false
]

{ #category : #'widget API' }
SpwWindow_A >> isMinimized [

	self widgetDo: [ :w | ^ w isMinimized ].
	^ false
]

{ #category : #'widget API' }
SpwWindow_A >> isResizable [

	^ self model isResizable
]

{ #category : #'spec protocol' }
SpwWindow_A >> isTopWindow [

	self widgetDo: [ :w | ^ w isTopWindow ].
	^ false
]

{ #category : #'spec protocol' }
SpwWindow_A >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : #'spec protocol' }
SpwWindow_A >> minimize [

	self widgetDo: [ :w | w minimize ]
]

{ #category : #'widget API' }
SpwWindow_A >> okToChange [

	^ self model okToChange
]

{ #category : #protocol }
SpwWindow_A >> open [

	self openWithDeferredAction: [  ]
]

{ #category : #protocol }
SpwWindow_A >> openWithDeferredAction: aBlock [

	"self flag: #TODO." "This and its children are more or less the same, it needs to be 
	revisited looking oportunities to improve the code reuse :("
	"self widget openInWorld."
"	self presenter initialPosition 
		ifNotNil: [ :aPosition | self widget position: aPosition ].
	self presenter isCentered 
		ifTrue: [ self centered ].
	self presenter presenter takeKeyboardFocus."
	self windowIsOpened.
	aBlock value
]

{ #category : #protocol }
SpwWindow_A >> rebuildWithSpecLayout: aSpec [

	| sub |
	sub := self model window submorphs copy.
	self model window removeAllMorphs.
	sub allButLast do: [ :e | self model window addMorphBack: e ].
	self model addPresenterIn: self widget withSpecLayout: aSpec.
	self widget model: self
]

{ #category : #'widget API' }
SpwWindow_A >> resize: aPoint [

	widget extent: aPoint
]

{ #category : #factory }
SpwWindow_A >> subscribeToAnnouncements: aWindow [

	aWindow announcer 
		when: SpWindowWillClose send: #announce: to: self presenter announcer;
		when: SpWindowResizing send: #announce: to: self presenter announcer;
		when: WindowClosed send: #windowClosed to: self
]

{ #category : #icons }
SpwWindow_A >> taskbarIcon [

	^ self model taskbarIcon
]

{ #category : #'widget API' }
SpwWindow_A >> title [

	^ self model title
]

{ #category : #'widget API' }
SpwWindow_A >> title: aString [

	"self widgetDo: [ :w | 
		w setLabel: (aString ifNotNil: [ :theString | 
				 theString localizedForPresenter: self presenter ]) ]"
]

{ #category : #updating }
SpwWindow_A >> windowClosed [

	self windowIsClosing.
	self presenter windowClosed
]

{ #category : #updating }
SpwWindow_A >> windowIsClosing [

	self model windowIsClosing
]

{ #category : #updating }
SpwWindow_A >> windowIsOpened [

	self presenter windowIsOpened
]
