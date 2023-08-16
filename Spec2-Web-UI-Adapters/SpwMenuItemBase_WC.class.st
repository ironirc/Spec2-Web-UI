Class {
	#name : #'SpwMenuItemBase_WC',
	#superclass : #'SpwAbstract_WC',
	#instVars : [
		'container',
		'label',
		'icon'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #testing }
SpwMenuItemBase_WC class >> isAbstract [

	^ self = SpwMenuItemBase_WC
]

{ #category : #actions }
SpwMenuItemBase_WC >> activate [
	PjDomController cssClassesAddAll: { 'active' } element: self.
	self menu focus
]

{ #category : #accessing }
SpwMenuItemBase_WC >> connectedForFirstTime [

	super connectedForFirstTime.
	self addEventListener: 'click' block: [ :clickEvent | self select ].
	self addEventListener: 'mouseenter' block: [ :evt | self menu activateItem: self ]
]

{ #category : #accessing }
SpwMenuItemBase_WC >> cssText [ 

	^'
:host {
	display: block;
	background-color: lightgray;
	transition: filter 0.1s ease-in-out;
	-webkit-user-select: none;  /* Chrome, Safari, Opera */
	-moz-user-select: none;   /* Firefox */
	-ms-user-select: none;   /* IE/Edge */
	user-select: none;   /* Standard syntax */
}
:host(.active){
	filter: brightness(80%);
}
.container {
	position: relative;
}
'
]

{ #category : #actions }
SpwMenuItemBase_WC >> deactivate [

	| event |
	PjDomController cssClassesRemoveAll: { 'active' } element: self.
	event := global CustomEvent
		         new: 'deactivate'
		         with:
		         { ('detail' -> { ('itemId' -> self id) }) } asJsObject.
	^ self dispatchEvent: event
]

{ #category : #accessing }
SpwMenuItemBase_WC >> icon [

	^ icon
]

{ #category : #accessing }
SpwMenuItemBase_WC >> icon: anObject [

	icon := anObject
]

{ #category : #accessing }
SpwMenuItemBase_WC >> label [

	^ label
]

{ #category : #accessing }
SpwMenuItemBase_WC >> label: anObject [

	label := anObject.
	self render
]

{ #category : #accessing }
SpwMenuItemBase_WC >> menu [

	^ self parentElement
]

{ #category : #actions }
SpwMenuItemBase_WC >> nextItem [ 

	^self menu itemAfter: self
]

{ #category : #actions }
SpwMenuItemBase_WC >> previousItem [ 

	^self menu itemBefore: self
]

{ #category : #accessing }
SpwMenuItemBase_WC >> renderOn: x [

	x style: self cssText.
	x div: [ :el |
		container := el.
		x _class: 'container'.
		self icon ifNotNil: [ :i | i renderOn: x ].
		self label ifNotNil: [ x << self label ] ]
]

{ #category : #actions }
SpwMenuItemBase_WC >> select [

	self menu
		selectItem: self;
		closeSelfAndOwners
]

{ #category : #accessing }
SpwMenuItemBase_WC >> subMenu [

	^ nil
]
