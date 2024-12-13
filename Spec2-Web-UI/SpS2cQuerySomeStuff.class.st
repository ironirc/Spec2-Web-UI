Class {
	#name : 'SpS2cQuerySomeStuff',
	#superclass : 'SpS2cMessageWithElementId',
	#instVars : [
		'selectors'
	],
	#category : 'Spec2-Web-UI-serverToClientMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'serverToClientMessages'
}

{ #category : 'testing' }
SpS2cQuerySomeStuff >> executeInResponseContext: rc [

	| msg el |
	msg := SpC2sQueryResponse new.
	msg sourceId: elementId.
	el := self element.
	msg results:
		(self selectors collect: [ :sel | sel -> (el perform: sel) ]).
	rc sendResponseMessage: msg
]

{ #category : 'testing' }
SpS2cQuerySomeStuff >> expectsResponseFromClient [ 
	^true
]

{ #category : 'accessing' }
SpS2cQuerySomeStuff >> selectors [

	^ selectors
]

{ #category : 'accessing' }
SpS2cQuerySomeStuff >> selectors: anObject [

	selectors := anObject
]
