Class {
	#name : #SpS2cUpdateElement2,
	#superclass : #SpS2cMessage,
	#instVars : [
		'elementId',
		'tag',
		'attributes',
		'events',
		'styles',
		'textContent',
		'parentId'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cUpdateElement2 >> attributes [

	^ attributes
]

{ #category : #accessing }
SpS2cUpdateElement2 >> attributes: anObject [

	attributes := anObject
]

{ #category : #accessing }
SpS2cUpdateElement2 >> elementId [

	^ elementId
]

{ #category : #accessing }
SpS2cUpdateElement2 >> elementId: anObject [

	elementId := anObject
]

{ #category : #private }
SpS2cUpdateElement2 >> ensuredElementIn: rc [

	^ (self document getElementById: elementId) ifNil: [ 
		  | el |
		  el := self document createElement: tag.
		  el setAttribute: 'id' value: elementId.
		  events do: [ :eventType | 
			  el addEventListener: eventType block: [ 
				  | msg |
				  msg := SpC2sEvent new.
				  msg sourceId: elementId.
				  rc clientOps sendMessageToServer: msg ] ].
		  el ]
]

{ #category : #accessing }
SpS2cUpdateElement2 >> events [

	^ events
]

{ #category : #accessing }
SpS2cUpdateElement2 >> events: anObject [

	events := anObject
]

{ #category : #private }
SpS2cUpdateElement2 >> executeInResponseContext: rc [

	| el x |
	el := self ensuredElementIn: rc.
	x := PjDomBuilder newOnElement: el.
	self updateOn: x.
	(document contains: el) ifFalse: [ document body appendChild: el ].
	parentId ifNotNil: [ 
		(self document getElementById: parentId) appendChild: el ]
]

{ #category : #accessing }
SpS2cUpdateElement2 >> parentId [

	^ parentId
]

{ #category : #accessing }
SpS2cUpdateElement2 >> parentId: anObject [

	parentId := anObject
]

{ #category : #accessing }
SpS2cUpdateElement2 >> styles [

	^ styles
]

{ #category : #accessing }
SpS2cUpdateElement2 >> styles: anObject [

	styles := anObject
]

{ #category : #accessing }
SpS2cUpdateElement2 >> tag [

	^ tag
]

{ #category : #accessing }
SpS2cUpdateElement2 >> tag: anObject [

	tag := anObject
]

{ #category : #accessing }
SpS2cUpdateElement2 >> textContent [

	^ textContent
]

{ #category : #accessing }
SpS2cUpdateElement2 >> textContent: anObject [

	textContent := anObject
]

{ #category : #private }
SpS2cUpdateElement2 >> updateOn: x [

	styles ifNotNil: [x _style: styles].
	attributes ifNotNil: [x _attr: attributes].
	textContent ifNotNil: [ x _text: textContent ].

]
