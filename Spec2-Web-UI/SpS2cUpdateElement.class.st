Class {
	#name : #SpS2cUpdateElement,
	#superclass : #SpS2cMessageWithElementId,
	#instVars : [
		'attributes',
		'styles',
		'textContent',
		'value',
		'properties',
		'visible'
	],
	#category : #'Spec2-Web-UI-serverToClientMessages'
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
SpS2cUpdateElement >> executeInResponseContext: rc [

	| el x |
	el := self ensuredElementIn: rc.
	x := PjDomBuilder newOnElement: el.
	self updateElement: el builder: x
]

{ #category : #accessing }
SpS2cUpdateElement >> properties [

	^ properties
]

{ #category : #accessing }
SpS2cUpdateElement >> properties: anObject [

	properties := anObject
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
SpS2cUpdateElement >> updateElement: el builder: x [
	"console log: 'updating element:' with: el. "
	styles ifNotNil: [x _style: styles].
	attributes ifNotNil: [x _attr: attributes].
	textContent ifNotNil: [ x _text: textContent ].
	value ifNotNil: [ el value: value ].
	properties ifNotNil: [el initializeWithProperties: properties ].
	visible ifNotNil: [
		console log:  'visibility:' with: el with: el style. 
		el style visibility: (visible
				 ifTrue: [ 'visible' ]
				 ifFalse: [ 'hidden' ]) ].	

]

{ #category : #accessing }
SpS2cUpdateElement >> value [

	^ value
]

{ #category : #accessing }
SpS2cUpdateElement >> value: anObject [

	value := anObject
]

{ #category : #accessing }
SpS2cUpdateElement >> visible [

	^ visible
]

{ #category : #accessing }
SpS2cUpdateElement >> visible: anObject [

	visible := anObject
]
