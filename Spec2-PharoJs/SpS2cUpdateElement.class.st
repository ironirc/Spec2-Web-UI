Class {
	#name : #SpS2cUpdateElement,
	#superclass : #SpS2cMessage,
	#instVars : [
		'elementId',
		'attributes',
		'events',
		'styles',
		'textContent',
		'value'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cUpdateElement >> attributes [

	^ attributes
]

{ #category : #accessing }
SpS2cUpdateElement >> attributes: anObject [

	attributes := anObject
]

{ #category : #accessing }
SpS2cUpdateElement >> elementId [

	^ elementId
]

{ #category : #accessing }
SpS2cUpdateElement >> elementId: anObject [

	elementId := anObject
]

{ #category : #private }
SpS2cUpdateElement >> ensuredElementIn: rc [

	^ (self document getElementById: elementId) ifNil: [ 
		  | el |
		  el := self document createElement: self tag.
		  el setAttribute: 'id' value: elementId.
		  events do: [ :eventName | 
			  | cls |
			  cls := SpC2sEvent forEventName: eventName.
			  el addEventListener: eventName block: [:nativeEvent |
				  | msg |
				  msg := cls newForNativeEvent: nativeEvent.
				  msg sourceId: elementId.
				  rc clientOps sendMessageToServer: msg ] ].
		  el ]
]

{ #category : #accessing }
SpS2cUpdateElement >> events [

	^ events
]

{ #category : #accessing }
SpS2cUpdateElement >> events: anObject [

	events := anObject
]

{ #category : #private }
SpS2cUpdateElement >> executeInResponseContext: rc [

	| el x |
	el := self ensuredElementIn: rc.
	x := PjDomBuilder newOnElement: el.
	self updateOn: x.
	(document contains: el) ifFalse: [ document body appendChild: el ].

]

{ #category : #accessing }
SpS2cUpdateElement >> styles [

	^ styles
]

{ #category : #accessing }
SpS2cUpdateElement >> styles: anObject [

	styles := anObject
]

{ #category : #accessing }
SpS2cUpdateElement >> textContent [

	^ textContent
]

{ #category : #accessing }
SpS2cUpdateElement >> textContent: anObject [

	textContent := anObject
]

{ #category : #private }
SpS2cUpdateElement >> updateOn: x [

	styles ifNotNil: [x _style: styles].
	attributes ifNotNil: [x _attr: attributes].
	textContent ifNotNil: [ x _text: textContent ].
	value ifNotNil: [ x currentElement value: value ]

]

{ #category : #accessing }
SpS2cUpdateElement >> value [

	^ value
]

{ #category : #accessing }
SpS2cUpdateElement >> value: anObject [

	value := anObject
]
