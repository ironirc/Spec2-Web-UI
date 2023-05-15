Class {
	#name : #SpjRemoteElement,
	#superclass : #PjDomController,
	#instVars : [
		'id',
		'oldMorphClass',
		'description',
		'ownerAdapter',
		'presenter',
		'visible',
		'extent',
		'listDirection',
		'borderWidth',
		'children',
		'creatorMethod',
		'requestContext'
	],
	#classVars : [
		'idCount'
	],
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #services }
SpjRemoteElement class >> currentIdCount [

	^ idCount
]

{ #category : #services }
SpjRemoteElement class >> incrementIdCount [

	idCount := idCount + 1
]

{ #category : #services }
SpjRemoteElement class >> initialize [
	idCount := 1.
]

{ #category : #services }
SpjRemoteElement class >> nextIdNumber [

	self incrementIdCount.
	^ self currentIdCount
]

{ #category : #services }
SpjRemoteElement class >> nextIdString [

	^ 'el-' , self nextIdNumber printString
]

{ #category : #printing }
SpjRemoteElement >> bindKeyCombination: aShortcut toAction: anAction [
"	self kmDispatcher bindKeyCombination: aShortcut asKeyCombination toAction: anAction"
]

{ #category : #accessing }
SpjRemoteElement >> borderWidth [

	^ borderWidth
]

{ #category : #accessing }
SpjRemoteElement >> borderWidth: anObject [

	borderWidth := anObject
]

{ #category : #'initialize-release' }
SpjRemoteElement >> children [
	^children
]

{ #category : #services }
SpjRemoteElement >> createRemote [
	
	| msg |
	self flag: 'delete me'.
	msg := PhxSpaExeExecuteCode javascript:
		       'document.body.appendChild(document.createElement("button"));'.
	self ownerAdapter application context sendMessage: msg
]

{ #category : #accessing }
SpjRemoteElement >> creatorMethod [

	^ creatorMethod
]

{ #category : #accessing }
SpjRemoteElement >> creatorMethod: anObject [

	creatorMethod := anObject
]

{ #category : #accessing }
SpjRemoteElement >> description [

	^ description
]

{ #category : #accessing }
SpjRemoteElement >> description: anObject [

	description := anObject
]

{ #category : #accessing }
SpjRemoteElement >> extent [

	^ extent
]

{ #category : #accessing }
SpjRemoteElement >> extent: anObject [

	extent := anObject
]

{ #category : #printing }
SpjRemoteElement >> id [

	^ id
]

{ #category : #'initialize-release' }
SpjRemoteElement >> initialize [

	super initialize.
	id := self class nextIdString.
	children := OrderedCollection new. 
]

{ #category : #accessing }
SpjRemoteElement >> listDirection [

	^ listDirection
]

{ #category : #accessing }
SpjRemoteElement >> listDirection: anObject [

	listDirection := anObject
]

{ #category : #accessing }
SpjRemoteElement >> oldMorphClass [

	^ oldMorphClass
]

{ #category : #accessing }
SpjRemoteElement >> oldMorphClass: anObject [

	oldMorphClass := anObject
]

{ #category : #accessing }
SpjRemoteElement >> ownerAdapter [

	^ ownerAdapter
]

{ #category : #accessing }
SpjRemoteElement >> ownerAdapter: anObject [

	ownerAdapter := anObject
]

{ #category : #accessing }
SpjRemoteElement >> presenter [

	^ presenter
]

{ #category : #accessing }
SpjRemoteElement >> presenter: anObject [

	presenter := anObject
]

{ #category : #printing }
SpjRemoteElement >> printOn: ws [

	ws << 'Rm-'.
	ws << id. 
	ws << '('.
	oldMorphClass ifNotNil: [ ws << oldMorphClass name ].
	ws << ')'
]

{ #category : #accessing }
SpjRemoteElement >> requestContext [

	^ requestContext
]

{ #category : #accessing }
SpjRemoteElement >> requestContext: anObject [

	requestContext := anObject
]

{ #category : #accessing }
SpjRemoteElement >> visible [

	^ visible
]

{ #category : #accessing }
SpjRemoteElement >> visible: anObject [

	visible := anObject
]
