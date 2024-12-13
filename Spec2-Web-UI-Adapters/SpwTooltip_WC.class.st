Class {
	#name : 'SpwTooltip_WC',
	#superclass : 'SpwAbstract_WC',
	#instVars : [
		'referenceElement',
		'label',
		'arrow',
		'mouseEnterListener',
		'mouseLeaveListener',
		'mouseDownListener'
	],
	#category : 'Spec2-Web-UI-Adapters-WebComponents',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'WebComponents'
}

{ #category : 'as yet unclassified' }
SpwTooltip_WC class >> tagName [

	^ 'spw-tooltip'
]

{ #category : 'rendering' }
SpwTooltip_WC >> cssText [ 

	^':host {
opacity: 0;
visibility: hidden;
transition: opacity 0.3s linear;
transition-delay: 0.25s;
width: max-content;
position: absolute;
top: 0;
left: 0;
background: #222;
color: white;
font-weight: bold;
padding: 5px;
border-radius: 4px;
font-size: 80%;
}

:host(.show) {
opacity: 1;
visibility: visible;
}

.arrow {
position: absolute;
background: #222;
width: 8px;
height: 8px;
transform: rotate(45deg);
}

'
]

{ #category : 'actions' }
SpwTooltip_WC >> hide [
	PjDomController cssClassesRemoveAll: { 'show' } element: self
]

{ #category : 'accessing' }
SpwTooltip_WC >> label [

	^ label
]

{ #category : 'accessing' }
SpwTooltip_WC >> label: anObject [

	label := anObject
]

{ #category : 'accessing' }
SpwTooltip_WC >> mouseDownListener [

	mouseDownListener ifNil: [ mouseDownListener := [ self hide ] ].
	^ mouseDownListener
]

{ #category : 'accessing' }
SpwTooltip_WC >> mouseEnterListener [

	mouseEnterListener ifNil: [ mouseEnterListener := [ self show ] ].
	^ mouseEnterListener
]

{ #category : 'accessing' }
SpwTooltip_WC >> mouseLeaveListener [

	mouseLeaveListener ifNil: [ mouseLeaveListener := [ self hide ] ].
	^ mouseLeaveListener
]

{ #category : 'rendering' }
SpwTooltip_WC >> promiseComputedPosition [

	| FUI |
	FUI := globalThis FloatingUIDOM.
	^ FUI
		  computePosition: self referenceElement
		  for: self
		  with: { ('middleware' -> {
				   (FUI offset: 6).
				   FUI autoPlacement.
				   (FUI shift: { ('padding' -> 5) } asJsObject).
				   (FUI arrow: { ('element' -> arrow) } asJsObject) }) }
				  asJsObject
]

{ #category : 'accessing' }
SpwTooltip_WC >> referenceElement [

	^ referenceElement
]

{ #category : 'accessing' }
SpwTooltip_WC >> referenceElement: refEl [
	referenceElement := refEl.
	refEl addEventListener: 'mouseenter' block:  self mouseEnterListener .
	refEl addEventListener: 'mouseleave' block: self mouseLeaveListener.
	refEl addEventListener: 'mousedown' block: self mouseDownListener.

]

{ #category : 'rendering' }
SpwTooltip_WC >> renderOn: x [

	x style: self cssText.
	x << self label.
	x div: [ :el |
		arrow := el.
		x _class: 'arrow' ]
]

{ #category : 'actions' }
SpwTooltip_WC >> show [
	PjDomController cssClassesElement: self set: { 'show' }.
	self updatePosition.
	

]

{ #category : 'rendering' }
SpwTooltip_WC >> updatePosition [

	self promiseComputedPosition ifNotNil: [ :prom |
		prom then: [ :obj | self updatePositionWith: obj ] ]
]

{ #category : 'rendering' }
SpwTooltip_WC >> updatePositionWith: pos [

	| pl arrOffs |
	self style left: pos x px.
	self style top: pos y px.
	arrow ifNil: [ ^ self ].
	arrow style left:
		(pos middlewareData arrow x ifNotNil: [ :x | x px ]).
	arrow style top: (pos middlewareData arrow y ifNotNil: [ :y | y px ]).
	pl := pos placement.
	arrOffs := -4 px.
	(pl beginsWith: 'top') ifTrue: [ arrow style bottom: arrOffs ].
	(pl beginsWith: 'right') ifTrue: [ arrow style left: arrOffs ].
	(pl beginsWith: 'bottom') ifTrue: [ arrow style top: arrOffs ].
	(pl beginsWith: 'left') ifTrue: [ arrow style right: arrOffs ]
]
