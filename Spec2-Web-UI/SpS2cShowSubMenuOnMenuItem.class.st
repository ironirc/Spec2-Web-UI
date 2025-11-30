Class {
	#name : 'SpS2cShowSubMenuOnMenuItem',
	#superclass : 'SpS2cMessageWithElementId',
	#instVars : [
		'targetId'
	],
	#category : 'Spec2-Web-UI-serverToClientMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'serverToClientMessages'
}

{ #category : 'accessing' }
SpS2cShowSubMenuOnMenuItem >> executeInResponseContext: rc [

	| menuEl menuItemEl rect x |
	menuEl := self element.
	SpwClientApp current removeKey: elementId.
	menuItemEl := self getElementById: targetId.
	x := PjDomBuilder newOnElement: document body.
	x tag: SpwMenuPopup_WC tagName with: [ :mpu |
		| deactivateListener |
		deactivateListener := [ :ev |
		                      mpu remove.
		                      menuItemEl subMenu: nil.
		                      menuItemEl
			                      removeEventListener: 'deactivate'
			                      with: deactivateListener ].
		menuItemEl addEventListener: 'deactivate' block: deactivateListener.
		mpu appendChild: menuEl.
		rect := menuItemEl getBoundingClientRect.
		mpu style top: rect top px.
		mpu style left: rect right px.
		menuItemEl subMenu: menuEl. ]
]

{ #category : 'accessing' }
SpS2cShowSubMenuOnMenuItem >> executeInResponseContext_ALT: rc [

	| menuEl menuItemEl rect  mpu |
	menuEl := self element.
	SpwClientApp current removeKey: elementId.
	menuItemEl := self getElementById: targetId.

	mpu := document createElement: SpwMenuPopup_WC tagName.
	mpu appendChild: menuEl.
	rect := menuItemEl getBoundingClientRect.
	mpu style top: rect top px.
	mpu style left: rect right px.
	menuItemEl appendChild: mpu
]

{ #category : 'accessing' }
SpS2cShowSubMenuOnMenuItem >> targetId [

	^ targetId
]

{ #category : 'accessing' }
SpS2cShowSubMenuOnMenuItem >> targetId: anObject [

	targetId := anObject
]

{ #category : 'accessing' }
SpS2cShowSubMenuOnMenuItem >> tippyShowElement: el forRefElement: targetEl [

	| tippy |
	console
		log: 'tippy el:'
		with: el
		with: ' target:'
		with: targetEl.
	tippy := global tippy new: targetEl with: {
			         ('placement' -> 'auto-end').
			         ('arrow' -> false).
			         ('interactive' -> true).
			         ('content' -> el).
			         ('theme' -> 'translucent') } asJsObject.
	tippy show
]
