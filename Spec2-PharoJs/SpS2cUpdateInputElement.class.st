Class {
	#name : #SpS2cUpdateInputElement,
	#superclass : #SpS2cUpdateElement,
	#instVars : [
		'readOnly',
		'selectAll',
		'type',
		'disabled'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cUpdateInputElement >> disabled [

	^ disabled
]

{ #category : #accessing }
SpS2cUpdateInputElement >> disabled: anObject [

	disabled := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> readOnly [

	^ readOnly
]

{ #category : #accessing }
SpS2cUpdateInputElement >> readOnly: anObject [

	readOnly := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectAll [

	^ selectAll
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectAll: anObject [

	selectAll := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> tag [
	^'input'
]

{ #category : #accessing }
SpS2cUpdateInputElement >> type [

	^ type
]

{ #category : #accessing }
SpS2cUpdateInputElement >> type: anObject [

	type := anObject
]

{ #category : #updating }
SpS2cUpdateInputElement >> updateOn: x [

	super updateOn: x.
	readOnly ifNotNil: [ x currentElement readOnly: readOnly ].
	disabled ifNotNil: [ x currentElement disabled: disabled ].
	type ifNotNil: [ x currentElement type: type ].
	selectAll == true ifTrue: [ x currentElement select ]
]
