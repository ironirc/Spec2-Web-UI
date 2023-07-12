Class {
	#name : #SpAbstractPharoJsAdapter,
	#superclass : #SpAbstractAdapter,
	#instVars : [
		'mutedModelSubscriptions'
	],
	#classVars : [
		'idCount'
	],
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #accessing }
SpAbstractPharoJsAdapter class >> adaptingName [
	"Override me if adapter will not follow the common pattern"

	"remove 'SpMorphic' part and *in general*, I will have the adapting name"

	^ (self name withoutPrefix: 'SpPharoJs') asSymbol
]

{ #category : #accessing }
SpAbstractPharoJsAdapter class >> allAdapters [

	^ self allSubclasses
]

{ #category : #services }
SpAbstractPharoJsAdapter class >> currentIdCount [

	^ idCount
]

{ #category : #services }
SpAbstractPharoJsAdapter class >> incrementIdCount [

	idCount := idCount + 1
]

{ #category : #accessing }
SpAbstractPharoJsAdapter class >> initialize [
	idCount := 1.
]

{ #category : #services }
SpAbstractPharoJsAdapter class >> nextIdNumber [

	self incrementIdCount.
	^ self currentIdCount
]

{ #category : #services }
SpAbstractPharoJsAdapter class >> nextIdString [

	^ 'el-' , self nextIdNumber printString
]

{ #category : #'drag and drop' }
SpAbstractPharoJsAdapter >> acceptDropBlock [

	^ self model acceptDropBlock
]

{ #category : #'drag and drop - private' }
SpAbstractPharoJsAdapter >> acceptDroppingMorph: draggedMorph event: event inMorph: source [

	^ self acceptDropBlock cull: draggedMorph model model cull: event cull: source model model
]

{ #category : #initialization }
SpAbstractPharoJsAdapter >> adapt: aPresenter [
	
	super adapt: aPresenter.
	self subcribeToModel.
	"self addSettingsTo: self widget.
	self addKeyBindingsTo: self widget.
	self addEventsTo: self widget"
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> add: anAdapter [
	self widgetDo: [ :w | w spEnsureLayoutAndAddMorph: anAdapter widget ]
]

{ #category : #private }
SpAbstractPharoJsAdapter >> addContextMenuKeyBindings: aWidget [
	
	self flag: #TODO. "Take this from a configuration"
	self 
		bindKeyCombination: $t command mac | $t control unix | $t control win
		toAction: [ self showContextMenu ]

]

{ #category : #initialization }
SpAbstractPharoJsAdapter >> addFocusRotationKeyBindings [

	self presenter canTakeKeyboardFocus ifFalse: [ ^ self ].

	self 
		bindKeyCombination: Character tab asKeyCombination 
		toAction: [ self focusNext ]. 
	self
		bindKeyCombination: Character tab shift asKeyCombination 
		toAction: [ self focusPrevious ]
]

{ #category : #initialization }
SpAbstractPharoJsAdapter >> addKeyBindingsTo: aMorph [

	self addFocusRotationKeyBindings.
	self presenter contextKeyBindings ifNotNil: [ :aCategory | 
		aCategory allEntries keymaps do: [ :each |
			self 
				bindKeyCombination: each shortcut 
				toAction: each action ] ]
]

{ #category : #initialization }
SpAbstractPharoJsAdapter >> addSettingsTo: aMorph [
	
	self widget ifNil: [ ^ self ].
	"For some reason, some times (it seems to be in with menu groups) you do not have a 
	 Morph here (instead, you have a collection of morphs). This have to be an error 
	 somehow, but no time to dig at it."
	self widget isMorph
		ifTrue: [ self widget presenter: self presenter ].
	self applyVisibility
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> addStyle: aStyle [
	"ignore style and just apply it again (the new style will not there)"
	self applyStyle: self widget
]

{ #category : #accessing }
SpAbstractPharoJsAdapter >> application [ 

	^ self presenter application
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> applyStyle [

	self applyStyle: self widget
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> applyStyle: morph [
	"this will apply general properties to the built morph"

	self style applyTo: morph
]

{ #category : #initialization }
SpAbstractPharoJsAdapter >> applyVisibility [
	
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
SpAbstractPharoJsAdapter >> bind: sourceAspect with: targetAspect of: target read: readBlock [

	self model property: sourceAspect whenChangedDo: [ :val | 
		target
			perform: target asMutator
			with: (val ifNotNil: [ readBlock cull: val ]) ].
	self model observablePropertyNamed: sourceAspect
]

{ #category : #'protocol - shortcuts' }
SpAbstractPharoJsAdapter >> bindKeyCombination: aShortcut toAction: aBlock [

	"self widgetDo: [ :w | 
		w 
			bindKeyCombination: aShortcut 
			toAction: aBlock ]"
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> borderColor [

	^ self model borderColor
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> borderColor: color [

	self widget ifNotNil: [ :w | w borderColor: color ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> borderWidth [

	^ self model borderWidth
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> borderWidth: width [

	self widget ifNotNil: [ :w | w borderWidth: width ]
]

{ #category : #private }
SpAbstractPharoJsAdapter >> buildMenu: aMenuPresenter [

	^ aMenuPresenter 
		owner: self presenter;
		build
]

{ #category : #'spec protocol' }
SpAbstractPharoJsAdapter >> changed [

	^ self widgetDo: [ :w | w changed ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> color [

	^ self model color
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> color: color [

	self widgetDo: [ :w | w color: color ]
]

{ #category : #'spec protocol' }
SpAbstractPharoJsAdapter >> delete [
	
	self widgetDo: [ :w | w delete ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> disable [
	
	self model enabled: false
]

{ #category : #'drag and drop' }
SpAbstractPharoJsAdapter >> dragEnabled [

	^ self presenter dragEnabled
]

{ #category : #'drag and drop' }
SpAbstractPharoJsAdapter >> dragEnabled: aBoolean [

	self widget ifNotNil: [ :w | w dragEnabled: aBoolean ]
]

{ #category : #'drag and drop' }
SpAbstractPharoJsAdapter >> dropEnabled [

	^ self presenter dropEnabled
]

{ #category : #'drag and drop' }
SpAbstractPharoJsAdapter >> dropEnabled: aBoolean [

	self widget ifNotNil: [ :w | w dropEnabled: aBoolean ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> enable [

	self model enabled: true
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> enabled [
	^ self presenter isEnabled
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> enabled: aBoolean [

	"self widget ifNotNil: [ :w | w enabled: aBoolean ]"
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> extent [

	^ self widget extent
]

{ #category : #'focus handling' }
SpAbstractPharoJsAdapter >> focusNext [
	
	self presenter withWindowDo: [ :window | | presenters |
		presenters := window allPresentersInFocusOrder.
		(presenters 
			after: self presenter
			ifAbsent: [ presenters first ])
			takeKeyboardFocus ]
]

{ #category : #'focus handling' }
SpAbstractPharoJsAdapter >> focusPrevious [
	
	self presenter withWindowDo: [ :window | | presenters |
		presenters := window allPresentersInFocusOrder.
		(presenters 
			before: self presenter
			ifAbsent: [ presenters last ])
			takeKeyboardFocus ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> hRigid [
	
	self widgetDo: [ :w | w hResizing: #rigid ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> hShrinkWrap [
	
	self widgetDo: [ :w | w hResizing: #shrinkWrap ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> hSpaceFill [
	
	self widgetDo: [ :w | w hResizing: #spaceFill ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> help [

	^ self model help
]

{ #category : #accessing }
SpAbstractPharoJsAdapter >> helpText [
	
	^ self widget balloonText 
]

{ #category : #initialization }
SpAbstractPharoJsAdapter >> initialize [ 
	super initialize.
	mutedModelSubscriptions := Set new
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installEvent: anEvent [
	"Used when installing events into presenters already built"

	self widgetDo: [ :w |
		anEvent 
			installOn: self 
			target: (self eventHandlerReceiver: w) ]
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installFocusLostEvent: anEvent to: aWidget [

	aWidget announcer 
		when: MorphLostFocus
		do: [ anEvent action value ]
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installFocusReceivedEvent: anEvent to: aWidget [

	aWidget announcer 
		when: MorphGotFocus
		do: [ anEvent action value ]
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installKeyDownEvent: anEvent to: aWidget [

	aWidget 
		on: #keyDown
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installKeyUpEvent: anEvent to: aWidget [

	aWidget 
		on: #keyUp
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installMouseDoubleClickEvent: anEvent to: aWidget [

	aWidget 
		on: #doubleClick
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installMouseDownEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseDown
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installMouseEnterEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseEnter
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installMouseLeaveEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseLeave
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installMouseMoveEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseMove
		send: #value:
		to: anEvent action
]

{ #category : #'event installing' }
SpAbstractPharoJsAdapter >> installMouseUpEvent: anEvent to: aWidget [

	aWidget 
		on: #mouseUp
		send: #value:
		to: anEvent action
]

{ #category : #testing }
SpAbstractPharoJsAdapter >> isMorphicAdapter [

	^ true
]

{ #category : #visibility }
SpAbstractPharoJsAdapter >> isVisible [
	
	^ widget visible
]

{ #category : #emulating }
SpAbstractPharoJsAdapter >> keyDown: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	
	^ self 
		keyEvent: #keyDown
		code: keyCode 
		shift: shiftBoolean 
		meta: metaBoolean 
		control: controlBoolean 
		option: optionBoolean
]

{ #category : #emulating }
SpAbstractPharoJsAdapter >> keyEvent: type code: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
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
SpAbstractPharoJsAdapter >> keyPressed: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [
	
	^ self 
		keyEvent: #keystroke
		code: keyCode asciiValue
		shift: shiftBoolean 
		meta: metaBoolean 
		control: controlBoolean 
		option: optionBoolean
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> layout: aLayout [
	| layout |
	layout := aLayout asMorphicLayout.
	self widgetDo: [ :w | w layoutFrame: layout ].
]

{ #category : #'model subscriptions' }
SpAbstractPharoJsAdapter >> muteModelAspect: aspect while: aBlock [

	mutedModelSubscriptions add: aspect.
	aBlock ensure: [ mutedModelSubscriptions remove: aspect ]
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> presenterStyles [
	"The presenters in the style"

	^ self presenter styles
]

{ #category : #printing }
SpAbstractPharoJsAdapter >> printOn: ws [

	ws << 'a ' << self class name
]

{ #category : #'protocol - shortcuts' }
SpAbstractPharoJsAdapter >> removeKeyCombination: aShortcut [

	self widgetDo: [ :w | 
		w removeKeyCombination: aShortcut ]
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> removeStyle: aStyle [
	"ignore style and just apply it again (the removed style will not be there)"
	self applyStyle: self widget
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> removeSubWidgets [
	
	self widgetDo: [ :w | w removeAllMorphs ]
]

{ #category : #emulating }
SpAbstractPharoJsAdapter >> sendClickEvent [
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
SpAbstractPharoJsAdapter >> sendMessageToClient: msg [

	^ self webSocketSession sendEnvelope: msg wrapInEnvelope
]

{ #category : #emulating }
SpAbstractPharoJsAdapter >> sendRightClickEvent [
	| evt |

	evt := MouseButtonEvent new 
		setType: nil 
		position: widget center 
		which: MouseButtonEvent yellowButton 
		buttons: MouseButtonEvent yellowButton 
		hand: nil 
		stamp: nil.

	(widget handlesMouseDown: evt) ifTrue: [
		widget mouseDown: evt.
		widget mouseUp: evt ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> setBalloonText: aString [

	self widget ifNotNil: [ :w | 
		w setBalloonText: (
			aString ifNotNil: [ :theString | theString localizedForPresenter: self presenter ] ) ]
	
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> show [ 

	self widgetDo: #show
]

{ #category : #private }
SpAbstractPharoJsAdapter >> showContextMenu [

	self presenter contextMenu ifNil: [ ^ self ].
	self showMenu: self presenter contextMenu
]

{ #category : #private }
SpAbstractPharoJsAdapter >> showMenu: aValuable [
	| lastShownMenu |
	
	lastShownMenu := self buildMenu: aValuable value.
	lastShownMenu open
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> style [

	^ SpPharoJsStyle 
		fromStylesheet: self styleSheet 
		adapter: self
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> styleName [
	"i.e. SpButtonAdapter = button"
	
	^ ((self className withoutPrefix: 'SpMorphic') allButLast: 7) uncapitalized
]

{ #category : #styling }
SpAbstractPharoJsAdapter >> styleSheet [

	^ self application styleSheet
]

{ #category : #'model subscriptions' }
SpAbstractPharoJsAdapter >> subcribeTo: anAspect [

	self model property: anAspect whenChangedDo: [ 
		(mutedModelSubscriptions includes: anAspect) ifFalse: [ 
			self perform: (anAspect , 'Changed') asSymbol ] ]
]

{ #category : #'model subscriptions' }
SpAbstractPharoJsAdapter >> subcribeToAll: aspects [

	aspects do: [ :each | self subcribeTo: each ]
]

{ #category : #'model subscriptions' }
SpAbstractPharoJsAdapter >> subcribeToModel [


]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> takeKeyboardFocus [

	| msg |
	msg := SpS2cElementTakeFocus new.
	msg elementId: widget.
	self sendMessageToClient: msg
]

{ #category : #'drag and drop' }
SpAbstractPharoJsAdapter >> transferFor: passenger from: source [

	^ SpTransferPresenter new
		transfer: passenger;
		from: source;
		yourself
]

{ #category : #emulating }
SpAbstractPharoJsAdapter >> type: aString [

	aString do: [ :each | 
		self 
			keyPressed: each 
			shift: each isUppercase
			meta: false 
			control: false 
			option: false ]
]

{ #category : #releasing }
SpAbstractPharoJsAdapter >> unsubscribe [

	super unsubscribe.
	
	self presenter hasAnnouncer ifFalse: [ ^ self ].
	self presenter announcer 
		unsubscribe: self widget;
		unsubscribe: self
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> useProportionalLayout [

	self widgetDo: [ :w | w changeProportionalLayout ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> vRigid [
	
	self widgetDo: [ :w | w vResizing: #rigid ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> vShrinkWrap [
	
	self widgetDo: [ :w | w vResizing: #shrinkWrap ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> vSpaceFill [
	
	self widgetDo: [ :w | w vResizing: #spaceFill ]
]

{ #category : #private }
SpAbstractPharoJsAdapter >> webSocketSession [

	^ CurrentWebSocketSession value ifNil: [ self owner root adapter webSocketSession ]
]

{ #category : #protocol }
SpAbstractPharoJsAdapter >> when: anAnnouncement do: aBlock [

	self widgetDo: [ :w | w announcer
		when: anAnnouncement do: aBlock ]
]

{ #category : #emulating }
SpAbstractPharoJsAdapter >> widgetEventReceiver [
	
	^ self eventHandlerReceiver: widget
]
