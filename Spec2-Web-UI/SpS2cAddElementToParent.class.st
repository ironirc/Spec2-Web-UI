Class {
	#name : 'SpS2cAddElementToParent',
	#superclass : 'SpS2cMessageWithElementId',
	#instVars : [
		'parentId'
	],
	#category : 'Spec2-Web-UI-serverToClientMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'serverToClientMessages'
}

{ #category : 'accessing' }
SpS2cAddElementToParent >> executeInResponseContext: rc [

	| el |
	el := self element.
	(self getElementById: parentId) appendChild: el.
	SpwClientApp current removeKey: elementId
]

{ #category : 'accessing' }
SpS2cAddElementToParent >> parentId [

	^ parentId
]

{ #category : 'accessing' }
SpS2cAddElementToParent >> parentId: anObject [

	parentId := anObject
]
