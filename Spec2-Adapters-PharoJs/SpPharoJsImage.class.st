Class {
	#name : #SpPharoJsImage,
	#superclass : #Object,
	#instVars : [
		'b64Array',
		'fileExtension',
		'cacheKey'
	],
	#category : #'Spec2-Adapters-PharoJs-Table'
}

{ #category : #accessing }
SpPharoJsImage >> b64Array [

	^ b64Array
]

{ #category : #accessing }
SpPharoJsImage >> b64Array: anObject [

	b64Array := anObject
]

{ #category : #accessing }
SpPharoJsImage >> cacheKey [

	^ cacheKey
]

{ #category : #accessing }
SpPharoJsImage >> cacheKey: anObject [

	cacheKey := anObject
]

{ #category : #accessing }
SpPharoJsImage >> fileExtension [

	^ fileExtension
]

{ #category : #accessing }
SpPharoJsImage >> fileExtension: anObject [

	fileExtension := anObject
]
