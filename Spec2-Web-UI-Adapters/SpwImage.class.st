Class {
	#name : #SpwImage,
	#superclass : #Object,
	#instVars : [
		'b64Array',
		'fileExtension',
		'cacheKey'
	],
	#category : #'Spec2-Web-UI-Adapters-Table'
}

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
