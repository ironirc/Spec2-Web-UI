Class {
	#name : #SpS2cUpdateTabulatorTable,
	#superclass : #SpS2cMessageWithElementId,
	#instVars : [
		'selections',
		'deselections'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cUpdateTabulatorTable >> executeInResponseContext: rc [

	selections ifNotNil: [ 
		self element deselectAll.
		self element selectIndexes: selections ].
	deselections ifNotNil: [ self element deselectIndexes: selections ]
]

{ #category : #accessing }
SpS2cUpdateTabulatorTable >> selections [

	^ selections
]

{ #category : #accessing }
SpS2cUpdateTabulatorTable >> selections: anObject [

	selections := anObject
]
