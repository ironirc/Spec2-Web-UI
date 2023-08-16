Class {
	#name : #'SpwMenu_WC',
	#superclass : #'SpwAbstract_WC',
	#instVars : [
		'activeItem',
		'owner'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #'as yet unclassified' }
SpwMenu_WC class >> tagName [ 
	^'spw-menu'
]

{ #category : #actions }
SpwMenu_WC >> activateFirstItem [

	self activateItem: self items first
]

{ #category : #actions }
SpwMenu_WC >> activateItem: anItem [

	activeItem ifNotNil: [ activeItem deactivate ].
	activeItem := anItem.
	anItem ifNotNil: [ anItem activate ]
]

{ #category : #actions }
SpwMenu_WC >> closeSelfAndOwners [
	self owner ifNotNil: [ :o |
		o deactivate.
		o menu closeSelfAndOwners.
		^ self ].
	self activateItem: nil.
	self remove
]

{ #category : #'event handling' }
SpwMenu_WC >> connectedForFirstTime [

	super connectedForFirstTime.
	"document body addEventListener: 'click' block: [ self remove ]."
	console log: 'attaching listener to : ' with: self "shadowRoot". 
	self "shadowRoot"
		addEventListener: 'keydown'
		block: [ :e | self handleKeyDown: e ]
]

{ #category : #rendering }
SpwMenu_WC >> cssText [ 

	^'
:host {
display: block; /* make the custom element a block element */
outline: none;
}
'
]

{ #category : #'event handling' }
SpwMenu_WC >> handleKeyDown: e [

	e key = 'ArrowDown' ifTrue: [ ^ self navigateDown ].
	e key = 'ArrowUp' ifTrue: [ ^ self navigateUp ].
	e key = 'ArrowLeft' ifTrue: [ ^ self navigateLeft ].
	e key = 'ArrowRight' ifTrue: [ ^ self navigateRight ].
	e key = 'Escape' ifTrue: [
		^ activeItem ifNotNil: [ ^ self closeSelfAndOwners ] ].
	e key = 'Enter' ifTrue: [
		^ activeItem ifNotNil: [ ^ self selectActiveItem ] ]
]

{ #category : #'accessing derived' }
SpwMenu_WC >> itemAfter: anItem [ 

	^self items at: (self items indexOf: anItem) + 1
]

{ #category : #'accessing derived' }
SpwMenu_WC >> itemBefore: anItem [ 

	^self items at: (self items indexOf: anItem) - 1
]

{ #category : #'accessing derived' }
SpwMenu_WC >> items [ 

	^Array from: self children 
]

{ #category : #actions }
SpwMenu_WC >> navigateDown [

	self activateItem:
		((activeItem ifNotNil: [ activeItem nextItem ]) ifNil: [
			 self items first ])
]

{ #category : #actions }
SpwMenu_WC >> navigateLeft [

	self owner ifNotNil: [ :o |
		self activateItem: nil.
		o menu focus ]
]

{ #category : #actions }
SpwMenu_WC >> navigateRight [

	activeItem ifNotNil: [
		activeItem subMenu ifNotNil: [ :sm |
			sm focus.
			sm activateFirstItem ] ]
]

{ #category : #actions }
SpwMenu_WC >> navigateUp [

	self activateItem:
		((activeItem ifNotNil: [ activeItem previousItem ]) ifNil: [
			 self items last ])
]

{ #category : #accessing }
SpwMenu_WC >> owner [

	^ owner
]

{ #category : #accessing }
SpwMenu_WC >> owner: anObject [

	owner := anObject
]

{ #category : #rendering }
SpwMenu_WC >> renderOn: x [
	self tabIndex: 0. "makes the component focusable"
	x style: self cssText.
	x slot: [ :el |  ]
]

{ #category : #actions }
SpwMenu_WC >> selectActiveItem [

	activeItem ifNotNil: [ activeItem select ]
]

{ #category : #actions }
SpwMenu_WC >> selectItem: anItem [

	| event |
	event := global CustomEvent
		         new: 'itemselect'
		         with:
		         { ('detail' -> { ('itemId' -> anItem id) }) } asJsObject.
	self dispatchEvent: event.

]
