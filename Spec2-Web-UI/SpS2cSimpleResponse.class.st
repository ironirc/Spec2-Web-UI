Class {
	#name : #SpS2cSimpleResponse,
	#superclass : #SpS2cMessage,
	#instVars : [
		'payload'
	],
	#category : #'Spec2-Web-UI-serverToClientMessages'
}

{ #category : #accessing }
SpS2cSimpleResponse >> payload [

	^ payload
]

{ #category : #accessing }
SpS2cSimpleResponse >> payload: anObject [

	payload := anObject
]
