Class {
	#name : #SpS2cUpdateElement,
	#superclass : #SpS2cMessageWithElementId,
	#instVars : [
		'attributes',
		'events',
		'styles',
		'textContent',
		'value'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cUpdateElement >> addAttribute: attributeName value: aValue [

	self attributes:
		((self attributes ifNil: [ #(  ) ]) copyWith:
			 attributeName -> aValue)
]

{ #category : #accessing }
SpS2cUpdateElement >> addStyle: styleName value: aValue [

	self styles:
		((self styles ifNil: [ #(  ) ]) copyWith: styleName -> aValue)
]

{ #category : #accessing }
SpS2cUpdateElement >> attributes [

	^ attributes
]

{ #category : #accessing }
SpS2cUpdateElement >> attributes: anObject [

	attributes := anObject
]

{ #category : #private }
SpS2cUpdateElement >> createElement [

	| el |
	el := self document createElement: self tag.
	el setAttribute: 'id' value: elementId.
	^ el
]

{ #category : #private }
SpS2cUpdateElement >> ensuredElementIn: rc [

	^ self element ifNil: [ 
		  | el |
		  el := self createElement.
		  events do: [ :eventName | 
			  | cls |
			  cls := SpC2sWidgetEvent forEventName: eventName.
			  el addEventListener: eventName block: [ :nativeEvent | 
				  | msg |
				  msg := cls newForNativeEvent: nativeEvent.
				  msg sourceId: elementId.
				  rc wsHandler sendMessageToServer: msg ] ].
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
