Class {
	#name : #SpS2cAddElementToParent,
	#superclass : #SpS2cMessageWithElementId,
	#instVars : [
		'parentId'
	],
	#category : #'Spec2-Web-UI-serverToClientMessages'
}

{ #category : #accessing }
SpS2cAddElementToParent >> executeInResponseContext: rc [

	| el  |
	el := self element.
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
