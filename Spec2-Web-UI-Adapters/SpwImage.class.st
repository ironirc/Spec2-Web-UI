Class {
	#name : #SpwImage,
	#superclass : #Object,
	#instVars : [
		'b64Array',
		'fileExtension',
		'cacheKey'
	],
	#classInstVars : [
		'cache'
	],
	#category : #'Spec2-Web-UI-Adapters-Table'
}

{ #category : #accessing }
SpwImage class >> cache [

	cache ifNil: [ cache := Dictionary new ].
	^cache
]

{ #category : #accessing }
SpwImage class >> forForm: aForm [

	<pharoJsSkip>
	^ self cache at: aForm ifAbsentPut: [
		  | newInstance |
		  newInstance := SpwImage new.
		  newInstance b64Array: (ByteArray streamContents: [ :ws |
				   PNGReadWriter putForm: aForm onStream: ws ]) base64Encoded.
		  newInstance fileExtension: 'png'.
		  newInstance cacheKey: aForm hash.
		  newInstance ]
]

{ #category : #accessing }
SpwImage >> b64Array [

	^ b64Array
]

{ #category : #accessing }
SpwImage >> b64Array: anObject [

	b64Array := anObject
]

{ #category : #accessing }
SpwImage >> cacheKey [

	^ cacheKey
]

{ #category : #accessing }
SpwImage >> cacheKey: anObject [

	cacheKey := anObject
]

{ #category : #accessing }
SpwImage >> fileExtension [

	^ fileExtension
]

{ #category : #accessing }
SpwImage >> fileExtension: anObject [

	fileExtension := anObject
]

{ #category : #accessing }
SpwImage >> getB64Array [

	^ self class cache at: self cacheKey ifAbsentPut: [self b64Array]
]
