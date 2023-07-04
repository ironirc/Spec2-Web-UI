Class {
	#name : #SpS2cQuerySomeStuff,
	#superclass : #SpS2cMessageWithElementId,
	#instVars : [
		'selectors'
	],
	#category : #'Spec2-PharoJs-serverToClientMessages'
}

{ #category : #testing }
SpS2cQuerySomeStuff >> executeInResponseContext: rc [

	| msg el |
	msg := SpC2sQueryResponse new.
	msg sourceId: elementId.
	el := self element.
	msg results:
		(self selectors collect: [ :sel | sel -> (el perform: sel) ]).
	rc sendResponseMessage: msg
]

{ #category : #testing }
SpS2cQuerySomeStuff >> expectsResponse [ 
	^true
]

{ #category : #accessing }
SpS2cQuerySomeStuff >> selectors [

	^ selectors
]

{ #category : #accessing }
SpS2cQuerySomeStuff >> selectors: anObject [

	selectors := anObject
]
