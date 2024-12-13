Class {
	#name : 'SpwImage',
	#superclass : 'Object',
	#instVars : [
		'b64Array',
		'fileExtension',
		'cacheKey'
	],
	#classInstVars : [
		'cache'
	],
	#category : 'Spec2-Web-UI-Adapters-Table',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'Table'
}

{ #category : 'accessing' }
SpwImage class >> cache [

	cache ifNil: [ cache := Dictionary new ].
	^cache
]

{ #category : 'accessing' }
SpwImage >> b64Array [

	^ b64Array
]

{ #category : 'accessing' }
SpwImage >> b64Array: anObject [

	b64Array := anObject
]

{ #category : 'accessing' }
SpwImage >> cacheKey [

	^ cacheKey
]

{ #category : 'accessing' }
SpwImage >> cacheKey: anObject [

	cacheKey := anObject
]

{ #category : 'accessing' }
SpwImage >> fileExtension [

	^ fileExtension
]

{ #category : 'accessing' }
SpwImage >> fileExtension: anObject [

	fileExtension := anObject
]

{ #category : 'accessing' }
SpwImage >> getB64Array [

	^ self class cache at: self cacheKey ifAbsentPut: [self b64Array]
]

{ #category : 'rendering' }
SpwImage >> renderOn: x [

	x img: [ :i | i src: 'data:image/png;base64,' , self getB64Array ]
]
