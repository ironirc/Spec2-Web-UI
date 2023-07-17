Class {
	#name : #SpwAbstractAdapter,
	#superclass : #SpAbstractAdapter,
	#instVars : [
		'mutedModelSubscriptions'
	],
	#classVars : [
		'idCount'
	],
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #accessing }
SpwAbstractAdapter class >> adaptingName [
	"Override me if adapter will not follow the common pattern"

	"remove 'SpPharoJs' part and *in general*, I will have the adapting name"

	^ (((self name withoutPrefix: 'Spw') withoutSuffix: '_A') , 'Adapter') asSymbol
]

{ #category : #accessing }
SpwAbstractAdapter class >> allAdapters [

	^ self allSubclasses
]

{ #category : #services }
SpwAbstractAdapter class >> currentIdCount [

	^ idCount
]

{ #category : #services }
SpwAbstractAdapter class >> incrementIdCount [

	idCount := idCount + 1
]

{ #category : #accessing }
SpwAbstractAdapter class >> initialize [
	idCount := 1.
]

{ #category : #testing }
SpwAbstractAdapter class >> isAbstract [ 

	^self == SpwAbstractAdapter
]

{ #category : #services }
SpwAbstractAdapter class >> nextIdNumber [

	self incrementIdCount.
	^ self currentIdCount
]

{ #category : #services }
SpwAbstractAdapter class >> nextIdString [

	^ 'el-' , self nextIdNumber printString
]

{ #category : #accessing }
SpwAbstractAdapter class >> remoteWidgetClass [ 

	^SpwAbstractRemoteWidget
]

{ #category : #'drag and drop' }
SpwAbstractAdapter >> acceptDropBlock [

	^ self model acceptDropBlock
]

{ #category : #'drag and drop - private' }
SpwAbstractAdapter >> acceptDroppingMorph: draggedMorph event: event inMorph: source [

	^ self acceptDropBlock cull: draggedMorph model model cull: event cull: source model model
]

{ #category : #initialization }
SpwAbstractAdapter >> adapt: aPresenter [
	
	super adapt: aPresenter.
	self subcribeToModel.
	"self addSettingsTo: self widget.
	self addKeyBindingsTo: self widget.
	self addEventsTo: self widget"
]

{ #category : #protocol }
SpwAbstractAdapter >> add: anAdapter [
	self widgetDo: [ :w | w spEnsureLayoutAndAddMorph: anAdapter widget ]
]

{ #category : #private }
SpwAbstractAdapter >> addContextMenuKeyBindings: aWidget [
	
	self flag: #TODO. "Take this from a configuration"
	self 
		bindKeyCombination: $t command mac | $t control unix | $t control win
		toAction: [ self showContextMenu ]

]

{ #category : #initialization }
SpwAbstractAdapter >> addFocusRotationKeyBindings [

	self presenter canTakeKeyboardFocus ifFalse: [ ^ self ].

	self 
		bindKeyCombination: Character tab asKeyCombination 
		toAction: [ self focusNext ]. 
	self
		bindKeyCombination: Character tab shift asKeyCombination 
		toAction: [ self focusPrevious ]
]

{ #category : #initialization }
SpwAbstractAdapter >> addKeyBindingsTo: aMorph [

	self addFocusRotationKeyBindings.
	self presenter contextKeyBindings ifNotNil: [ :aCategory | 
		aCategory allEntries keymaps do: [ :each |
			self 
				bindKeyCombination: each shortcut 
				toAction: each action ] ]
]

{ #category : #initialization }
SpwAbstractAdapter >> addSettingsTo: aMorph [
	
	self widget ifNil: [ ^ self ].
	"For some reason, some times (it seems to be in with menu groups) you do not have a 
	 Morph here (instead, you have a collection of morphs). This have to be an error 
	 somehow, but no time to dig at it."
	self widget isMorph
		ifTrue: [ self widget presenter: self presenter ].
	self applyVisibility
]

{ #category : #styling }
SpwAbstractAdapter >> addStyle: aStyle [
	"ignore style and just apply it again (the new style will not there)"
	self applyStyle: self widget
]

{ #category : #accessing }
SpwAbstractAdapter >> application [ 

	^ self presenter application
]

{ #category : #styling }
SpwAbstractAdapter >> applyStyle [

	self applyStyle: self widget
]

{ #category : #styling }
SpwAbstractAdapter >> applyStyle: morph [
	"this will apply general properties to the built morph"

	self style applyTo: morph
]

{ #category : #initialization }
SpwAbstractAdapter >> applyVisibility [
	
	"It may happen that some presenters use generic adapters and they do not have an associated presenter.
	In that case, do not manage visibility..."
	self presenter ifNil: [ ^ self ].

	self widget visible: self presenter isVisible.
	self presenter whenVisibleChangedDo: [ :visible |
		self presenter isVisible
			ifTrue: [ self widget show ]
			ifFalse: [ self widget hide ] ]
]

{ #category : #initialization }
SpwAbstractAdapter >> bind: sourceAspect with: targetAspect of: target read: readBlock [

	self model property: sourceAspect whenChangedDo: [ :val | 
		target
			perform: target asMutator
			with: (val ifNotNil: [ readBlock cull: val ]) ].
	self model observablePropertyNamed: sourceAspect
]

{ #category : #'protocol - shortcuts' }
SpwAbstractAdapter >> bindKeyCombination: aShortcut toAction: aBlock [

	"self widgetDo: [ :w | 
		w 
			bindKeyCombination: aShortcut 
			toAction: aBlock ]"
]

{ #category : #protocol }
SpwAbstractAdapter >> borderColor [

	^ self model borderColor
]

{ #category : #protocol }
SpwAbstractAdapter >> borderColor: color [

	self widget ifNotNil: [ :w | w borderColor: color ]
]

{ #category : #protocol }
SpwAbstractAdapter >> borderWidth [

	^ self model borderWidth
]

{ #category : #protocol }
SpwAbstractAdapter >> borderWidth: width [

	self widget ifNotNil: [ :w | w borderWidth: width ]
]

{ #category : #private }
SpwAbstractAdapter >> buildMenu: aMenuPresenter [

	^ aMenuPresenter 
		owner: self presenter;
		build
]

{ #category : #'spec protocol' }
SpwAbstractAdapter >> changed [

	^ self widgetDo: [ :w | w changed ]
]

{ #category : #protocol }
SpwAbstractAdapter >> color [

	^ self model color
]

{ #category : #protocol }
SpwAbstractAdapter >> color: color [

	self widgetDo: [ :w | w color: color ]
]

{ #category : #'spec protocol' }
SpwAbstractAdapter >> delete [
	
	self widgetDo: [ :w | w delete ]
]

{ #category : #protocol }
SpwAbstractAdapter >> disable [
	
	self model enabled: false
]

{ #category : #'drag and drop' }
SpwAbstractAdapter >> dragEnabled [

	^ self presenter dragEnabled
]

{ #category : #'drag and drop' }
SpwAbstractAdapter >> dragEnabled: aBoolean [

	self widget ifNotNil: [ :w | w dragEnabled: aBoolean ]
]

{ #category : #'drag and drop' }
SpwAbstractAdapter >> dropEnabled [

	^ self presenter dropEnabled
]

{ #category : #'drag and drop' }
SpwAbstractAdapter >> dropEnabled: aBoolean [

	self widget ifNotNil: [ :w | w dropEnabled: aBoolean ]
]

{ #category : #protocol }
SpwAbstractAdapter >> enable [

	self model enabled: true
]

{ #category : #protocol }
SpwAbstractAdapter >> enabled [
	^ self presenter isEnabled
]

{ #category : #protocol }
SpwAbstractAdapter >> enabled: aBoolean [

	"self widget ifNotNil: [ :w | w enabled: aBoolean ]"
]

{ #category : #protocol }
SpwAbstractAdapter >> extent [

	^ self widget extent
]

{ #category : #'focus handling' }
SpwAbstractAdapter >> focusNext [
	
	self presenter withWindowDo: [ :window | | presenters |
		presenters := window allPresentersInFocusOrder.
		(presenters 
			after: self presenter
			ifAbsent: [ presenters first ])
			takeKeyboardFocus ]
]

{ #category : #'focus handling' }
SpwAbstractAdapter >> focusPrevious [
	
	self presenter withWindowDo: [ :window | | presenters |
		presenters := window allPresentersInFocusOrder.
		(presenters 
			before: self presenter
			ifAbsent: [ presenters last ])
			takeKeyboardFocus ]
]

{ #category : #protocol }
SpwAbstractAdapter >> hRigid [
	
	self widgetDo: [ :w | w hResizing: #rigid ]
]

{ #category : #protocol }
SpwAbstractAdapter >> hShrinkWrap [
	
	self widgetDo: [ :w | w hResizing: #shrinkWrap ]
]

{ #category : #protocol }
SpwAbstractAdapter >> hSpaceFill [
	
	self widgetDo: [ :w | w hResizing: #spaceFill ]
]

{ #category : #protocol }
SpwAbstractAdapter >> help [

	^ self model help
]

{ #category : #accessing }
SpwAbstractAdapter >> helpText [
	
	^ self widget balloonText 
]

{ #category : #initialization }
SpwAbstractAdapter >> initialize [ 
	super initialize.
	mutedModelSubscriptions := Set new
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installEvent: anEvent [
	"Used when installing events into presenters already built"

	self widgetDo: [ :w |
		anEvent 
			installOn: self 
			target: (self eventHandlerReceiver: w) ]
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installFocusLostEvent: anEvent to: aWidget [

	aWidget announcer 
		when: MorphLostFocus
		do: [ anEvent action value ]
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installFocusReceivedEvent: anEvent to: aWidget [

	aWidget announcer 
		when: MorphGotFocus
		do: [ anEvent action value ]
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installKeyDownEvent: anEvent to: aWidget [

	aWidget 
		on: #keyDown
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installKeyUpEvent: anEvent to: aWidget [

	aWidget 
		on: #keyUp
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installMouseDoubleClickEvent: anEvent to: aWidget [

	aWidget 
		on: #doubleClick
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installMouseDownEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseDown
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installMouseEnterEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseEnter
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installMouseLeaveEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseLeave
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installMouseMoveEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseMove
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpwAbstractAdapter >> installMouseUpEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseUp
		send: #value:
		to: anEvent action
]

{ #category : #testing }
SpwAbstractAdapter >> isMorphicAdapter [

	^ true
]

{ #category : #visibility }
SpwAbstractAdapter >> isVisible [
	
	^ widget visible
]

{ #category : #emulating }
SpwAbstractAdapter >> keyDown: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	
	^ self 
		keyEvent: #keyDown
		code: keyCode 
		shift: shiftBoolean 
		meta: metaBoolean 
		control: controlBoolean 
		option: optionBoolean
]

{ #category : #emulating }
SpwAbstractAdapter >> keyEvent: type code: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	| evt modifiers |
	
	modifiers := 0.
	shiftBoolean ifTrue: [ modifiers := modifiers | 8 ].
	metaBoolean ifTrue: [ modifiers := modifiers |
		(Smalltalk os isWindows | Smalltalk os isUnix
			ifTrue: [ 2r00010000 ]
			ifFalse: [ 2r01000000 ]) ].
	controlBoolean ifTrue: [ modifiers := modifiers | 2r00010000 ].
	optionBoolean ifTrue: [ modifiers := modifiers |
		(Smalltalk os isWindows | Smalltalk os isUnix
			ifTrue: [ 2r01000000 ]
			ifFalse: [ 2r00100000 ]) ].
		
	evt := KeyboardEvent new
		setType: type
		buttons: modifiers
		position: self widget position + (1 @ 1)
		keyValue: keyCode
		charCode: keyCode
		hand: self currentWorld activeHand
		stamp: Time millisecondClockValue.

	evt key: (KeyboardKey fromCharacter: keyCode asCharacter).
	evt sentTo: self widgetEventReceiver.
	"Some time to allow things to happen?"
	10 milliSeconds wait
]

{ #category : #emulating }
SpwAbstractAdapter >> keyPressed: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	
	^ self 
		keyEvent: #keystroke
		code: keyCode asciiValue
		shift: shiftBoolean 
		meta: metaBoolean 
		control: controlBoolean 
		option: optionBoolean
]

{ #category : #protocol }
SpwAbstractAdapter >> layout: aLayout [
	| layout |
	layout := aLayout asMorphicLayout.
	self widgetDo: [ :w | w layoutFrame: layout ].
]

{ #category : #'model subscriptions' }
SpwAbstractAdapter >> muteModelAspect: aspect while: aBlock [

	mutedModelSubscriptions add: aspect.
	aBlock ensure: [ mutedModelSubscriptions remove: aspect ]
]

{ #category : #private }
SpwAbstractAdapter >> newRemoteWidget [

	| w |
	w := self class remoteWidgetClass new.
	w id: self class nextIdString.
	w adaptor: self.
	^ w
]

{ #category : #styling }
SpwAbstractAdapter >> presenterStyles [
	"The presenters in the style"

	^ self presenter styles
]

{ #category : #printing }
SpwAbstractAdapter >> printOn: ws [

	ws << 'a ' << self class name
]

{ #category : #'protocol - shortcuts' }
SpwAbstractAdapter >> removeKeyCombination: aShortcut [

	self widgetDo: [ :w | 
		w removeKeyCombination: aShortcut ]
]

{ #category : #styling }
SpwAbstractAdapter >> removeStyle: aStyle [
	"ignore style and just apply it again (the removed style will not be there)"
	self applyStyle: self widget
]

{ #category : #protocol }
SpwAbstractAdapter >> removeSubWidgets [
	
	self widgetDo: [ :w | w removeAllMorphs ]
]

{ #category : #emulating }
SpwAbstractAdapter >> sendClickEvent [
	| evt |

	evt := MouseButtonEvent new 
		setType: nil 
		position: widget center 
		which: MouseButtonEvent redButton 
		buttons: MouseButtonEvent redButton 
		hand: nil 
		stamp: nil.

	(widget handlesMouseDown: evt) ifTrue: [
		widget handleMouseDown: evt.
		widget handleMouseUp: evt ]
]

{ #category : #websocket }
SpwAbstractAdapter >> sendMessageToClient: msg [

	^ self webSocketSession sendMessage: msg
]

{ #category : #emulating }
SpwAbstractAdapter >> sendRightClickEvent [
"	| evt |

	evt := MouseButtonEvent new 
		setType: nil 
		position: widget center 
		which: MouseButtonEvent yellowButton 
		buttons: MouseButtonEvent yellowButton 
		hand: nil 
		stamp: nil.

	(widget handlesMouseDown: evt) ifTrue: [
		widget mouseDown: evt.
		widget mouseUp: evt ]"
	
		| msg |
	msg := SpS2cElementRightClick new.
	msg elementId: self widget id.
	self sendMessageToClient: msg.
	

]

{ #category : #protocol }
SpwAbstractAdapter >> setBalloonText: aString [

	self widget ifNotNil: [ :w | 
		w setBalloonText: (
			aString ifNotNil: [ :theString | theString localizedForPresenter: self presenter ] ) ]
	
]

{ #category : #protocol }
SpwAbstractAdapter >> show [ 

	self widgetDo: #show
]

{ #category : #private }
SpwAbstractAdapter >> showContextMenu [

	self presenter contextMenu ifNil: [ ^ self ].
	self showMenu: self presenter contextMenu
]

{ #category : #private }
SpwAbstractAdapter >> showMenu: aValuable [
	| lastShownMenu |
	
	lastShownMenu := self buildMenu: aValuable value.
	lastShownMenu open
]

{ #category : #styling }
SpwAbstractAdapter >> style [

	^ SpwStyle 
		fromStylesheet: self styleSheet 
		adapter: self
]

{ #category : #styling }
SpwAbstractAdapter >> styleName [
	"i.e. SpButtonAdapter = button"
	
	^ ((self className withoutPrefix: 'SpMorphic') allButLast: 7) uncapitalized
]

{ #category : #styling }
SpwAbstractAdapter >> styleSheet [

	^ self application styleSheet
]

{ #category : #'model subscriptions' }
SpwAbstractAdapter >> subcribeTo: anAspect [

	self model property: anAspect whenChangedDo: [ 
		(mutedModelSubscriptions includes: anAspect) ifFalse: [ 
			self perform: (anAspect , 'Changed') asSymbol ] ]
]

{ #category : #'model subscriptions' }
SpwAbstractAdapter >> subcribeToAll: aspects [

	aspects do: [ :each | self subcribeTo: each ]
]

{ #category : #'model subscriptions' }
SpwAbstractAdapter >> subcribeToModel [


]

{ #category : #protocol }
SpwAbstractAdapter >> takeKeyboardFocus [

	| msg |
	msg := SpS2cElementTakeFocus new.
	msg elementId: widget.
	self sendMessageToClient: msg
]

{ #category : #'drag and drop' }
SpwAbstractAdapter >> transferFor: passenger from: source [

	^ SpTransferPresenter new
		transfer: passenger;
		from: source;
		yourself
]

{ #category : #emulating }
SpwAbstractAdapter >> type: aString [

	aString do: [ :each | 
		self 
			keyPressed: each 
			shift: each isUppercase
			meta: false 
			control: false 
			option: false ]
]

{ #category : #releasing }
SpwAbstractAdapter >> unsubscribe [

	super unsubscribe.
	
	self presenter hasAnnouncer ifFalse: [ ^ self ].
	self presenter announcer 
		unsubscribe: self widget;
		unsubscribe: self
]

{ #category : #protocol }
SpwAbstractAdapter >> useProportionalLayout [

	self widgetDo: [ :w | w changeProportionalLayout ]
]

{ #category : #protocol }
SpwAbstractAdapter >> vRigid [
	
	self widgetDo: [ :w | w vResizing: #rigid ]
]

{ #category : #protocol }
SpwAbstractAdapter >> vShrinkWrap [
	
	self widgetDo: [ :w | w vResizing: #shrinkWrap ]
]

{ #category : #protocol }
SpwAbstractAdapter >> vSpaceFill [
	
	self widgetDo: [ :w | w vResizing: #spaceFill ]
]

{ #category : #private }
SpwAbstractAdapter >> webSocketSession [

	^ CurrentWebSocketSession value ifNil: [
		  self owner root adapter webSocketSession ]
]

{ #category : #protocol }
SpwAbstractAdapter >> when: anAnnouncement do: aBlock [

	self widgetDo: [ :w | w announcer
		when: anAnnouncement do: aBlock ]
]

{ #category : #emulating }
SpwAbstractAdapter >> widgetEventReceiver [
	
	^ self eventHandlerReceiver: widget
]
