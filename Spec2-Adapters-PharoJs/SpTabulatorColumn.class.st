Class {
	#name : #SpTabulatorColumn,
	#superclass : #Object,
	#instVars : [
		'field',
		'index',
		'title',
		'width',
		'type'
	],
	#category : #'Spec2-Adapters-PharoJs-Table'
}

{ #category : #accessing }
SpTabulatorColumn >> field [

	^ field
]

{ #category : #accessing }
SpTabulatorColumn >> field: anObject [

	field := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> index [

	^ index
]

{ #category : #accessing }
SpTabulatorColumn >> index: anObject [

	index := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> title [

	^ title
]

{ #category : #accessing }
SpTabulatorColumn >> title: anObject [

	title := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> type [

	^ type
]

{ #category : #accessing }
SpTabulatorColumn >> type: anObject [

	type := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> width [

	^ width
]

{ #category : #accessing }
SpTabulatorColumn >> width: anObject [

	width := anObject
]
