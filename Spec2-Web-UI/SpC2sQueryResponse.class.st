Class {
	#name : 'SpC2sQueryResponse',
	#superclass : 'SpC2sEvent',
	#instVars : [
		'results'
	],
	#category : 'Spec2-Web-UI-clientToServerMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'clientToServerMessages'
}

{ #category : 'accessing' }
SpC2sQueryResponse >> results [

	^ results
]

{ #category : 'accessing' }
SpC2sQueryResponse >> results: anObject [

	results := anObject
]
