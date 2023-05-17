Class {
	#name : #SpPharoJsWindowAdapter,
	#superclass : #SpAbstractPharoJsWindowAdapter,
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> aboutTitle [
    ^ self model model
         ifNotNil: [ :m | (m respondsTo: #aboutTitle)
		ifTrue: [m aboutTitle]
		ifFalse: [m class name]].
]

{ #category : #initialization }
SpPharoJsWindowAdapter >> addFocusRotationKeyBindings [
	"Windows should not process keybindings (because then the active widget will not get 
	 the event)"
]

{ #category : #protocol }
SpPharoJsWindowAdapter >> addPresenterIn: aWindow withSpecLayout: aSpec [

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
SpPharoJsWindowAdapter >> askOkToClose [

	^ self model askOkToClose
]

{ #category : #protocol }
SpPharoJsWindowAdapter >> beep [ 
	
	widget flash
]

{ #category : #factory }
SpPharoJsWindowAdapter >> buildWidget [

	"^ SpWindow new  <- MORPHIC stuff !!!
		model: model;
		isResizeable: self isResizable;
		in: [ :this | self subscribeToAnnouncements: this ];
		yourself"

	| id msg |
	id := 'body'. "SpjRemoteElement nextIdString"
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: id.
	msg tag: 'div'.
	msg styles: { 
			('background-color' -> '#00C').
			"('height' -> '100vh')" }.
	msg attributes: { ('method' -> thisContext method printString) }.
	self sendUpdateMessageToClient: msg.
	^ id
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> cancelled [

	^ false
]

{ #category : #protocol }
SpPharoJsWindowAdapter >> centered [

	self widgetDo: [ :w | 
		w
			computeFullBounds;
			position: (self currentWorld extent - w extent) // 2 ]
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> centeredRelativeTo: aWindowPresenter [
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
SpPharoJsWindowAdapter >> close [

	"self widget ifNotNil: [ :w | w close ]"
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> delete [

	self widgetDo: [ :w | 
		w delete.
		self application windowClosed: self ]
]

{ #category : #protocol }
SpPharoJsWindowAdapter >> extent: aPoint [

	^ self widget extent: aPoint
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> initialExtent [

	^ self model initialExtent
]

{ #category : #'event installing' }
SpPharoJsWindowAdapter >> installFocusLostEvent: anEvent to: aWidget [

	aWidget announcer
		when: WindowDeActivated
		do: [ anEvent action value ]
]

{ #category : #'event installing' }
SpPharoJsWindowAdapter >> installFocusReceivedEvent: anEvent to: aWidget [

	aWidget announcer
		when: WindowActivated
		do: [ anEvent action value ]
]

{ #category : #protocol }
SpPharoJsWindowAdapter >> isDisplayed [

	^ self widget isDisplayed
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> isMaximized [

	self widgetDo: [ :w | ^ w isMaximized ].
	^ false
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> isMinimized [

	self widgetDo: [ :w | ^ w isMinimized ].
	^ false
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> isResizable [

	^ self model isResizable
]

{ #category : #'spec protocol' }
SpPharoJsWindowAdapter >> isTopWindow [

	self widgetDo: [ :w | ^ w isTopWindow ].
	^ false
]

{ #category : #'spec protocol' }
SpPharoJsWindowAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : #'spec protocol' }
SpPharoJsWindowAdapter >> minimize [

	self widgetDo: [ :w | w minimize ]
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> okToChange [

	^ self model okToChange
]

{ #category : #protocol }
SpPharoJsWindowAdapter >> open [

	self openWithDeferredAction: [  ]
]

{ #category : #protocol }
SpPharoJsWindowAdapter >> openWithDeferredAction: aBlock [

	self flag: #TODO. "This and its children are more or less the same, it needs to be 
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
SpPharoJsWindowAdapter >> rebuildWithSpecLayout: aSpec [

	| sub |
	sub := self model window submorphs copy.
	self model window removeAllMorphs.
	sub allButLast do: [ :e | self model window addMorphBack: e ].
	self model addPresenterIn: self widget withSpecLayout: aSpec.
	self widget model: self
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> resize: aPoint [

	widget extent: aPoint
]

{ #category : #factory }
SpPharoJsWindowAdapter >> subscribeToAnnouncements: aWindow [

	aWindow announcer 
		when: SpWindowWillClose send: #announce: to: self presenter announcer;
		when: SpWindowResizing send: #announce: to: self presenter announcer;
		when: WindowClosed send: #windowClosed to: self
]

{ #category : #icons }
SpPharoJsWindowAdapter >> taskbarIcon [

	^ self model taskbarIcon
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> title [

	^ self model title
]

{ #category : #'widget API' }
SpPharoJsWindowAdapter >> title: aString [

	self widgetDo: [ :w | 
		w setLabel: (aString ifNotNil: [ :theString | 
				 theString localizedForPresenter: self presenter ]) ]
]

{ #category : #updating }
SpPharoJsWindowAdapter >> windowClosed [

	self windowIsClosing.
	self presenter windowClosed
]

{ #category : #updating }
SpPharoJsWindowAdapter >> windowIsClosing [

	self model windowIsClosing
]

{ #category : #updating }
SpPharoJsWindowAdapter >> windowIsOpened [

	self presenter windowIsOpened
]
