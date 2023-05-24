Class {
	#name : #SpS2cCreateTabulatorTable,
	#superclass : #SpS2cUpdateElement,
	#instVars : [
		'data',
		'columns'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cCreateTabulatorTable >> columns [

	^ columns
]

{ #category : #accessing }
SpS2cCreateTabulatorTable >> columns: anObject [

	columns := anObject
]

{ #category : #accessing }
SpS2cCreateTabulatorTable >> data [

	^ data
]

{ #category : #accessing }
SpS2cCreateTabulatorTable >> data: anObject [

	data := anObject
]

{ #category : #private }
SpS2cCreateTabulatorTable >> tag [
	^'sp-table'
]

{ #category : #private }
SpS2cCreateTabulatorTable >> updateOn: x [

	| webComp |
	super updateOn: x.
	webComp := x currentElement.
	webComp tableBuiltPromise then: [ webComp setColumns: self columns ]
]
