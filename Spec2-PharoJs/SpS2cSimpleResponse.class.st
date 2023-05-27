Class {
	#name : #SpS2cSimpleResponse,
	#superclass : #SpS2cMessage,
	#instVars : [
		'payload'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cSimpleResponse >> payload [

	^ payload
]

{ #category : #accessing }
SpS2cSimpleResponse >> payload: anObject [

	payload := anObject
]
