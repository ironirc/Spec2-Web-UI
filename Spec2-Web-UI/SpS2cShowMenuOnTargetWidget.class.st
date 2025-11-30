Class {
	#name : 'SpS2cShowMenuOnTargetWidget',
	#superclass : 'SpS2cMessageWithElementId',
	#instVars : [
		'targetId'
	],
	#category : 'Spec2-Web-UI-serverToClientMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'serverToClientMessages'
}

{ #category : 'accessing' }
SpS2cShowMenuOnTargetWidget >> executeInResponseContext: rc [

	| menuEl targetEl rect x |
	menuEl := self element.
	SpwClientApp current removeKey: elementId. "remove from cache"
	targetEl := self getElementById: targetId.
	x := PjDomBuilder newOnElement: document body.
	x tag: SpwMenuPopup_WC tagName with: [ :mpu |
		| deactivateListener |
		deactivateListener := [ :ev |
		                      mpu remove.
		                      targetEl
			                      removeEventListener: 'deactivate'
			                      with: deactivateListener ].
		targetEl addEventListener: 'deactivate' block: deactivateListener.
		mpu appendChild: menuEl.
		rect := targetEl getBoundingClientRect.
		mpu style top: rect bottom px.
		mpu style left: rect left px.
		 ]
]

{ #category : 'accessing' }
SpS2cShowMenuOnTargetWidget >> executeInResponseContext_ALT: rc [

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
SpS2cShowMenuOnTargetWidget >> targetId [

	^ targetId
]

{ #category : 'accessing' }
SpS2cShowMenuOnTargetWidget >> targetId: anObject [

	targetId := anObject
]

{ #category : 'accessing' }
SpS2cShowMenuOnTargetWidget >> tippyShowElement: el forRefElement: targetEl [

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
