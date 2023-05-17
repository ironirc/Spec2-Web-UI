Class {
	#name : #SpS2cAddElementToParent,
	#superclass : #SpS2cUpdateElement,
	#instVars : [
		'parentId'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cAddElementToParent >> executeInResponseContext: rc [

	| el x |
	el := self document getElementById: elementId.
	(self document getElementById: parentId) appendChild: el
]

{ #category : #accessing }
SpS2cAddElementToParent >> parentId [

	^ parentId
]

{ #category : #accessing }
SpS2cAddElementToParent >> parentId: anObject [

	parentId := anObject
]
