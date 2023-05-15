Class {
	#name : #SpS2cUpdateElement,
	#superclass : #SpS2cMessage,
	#instVars : [
		'element'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cUpdateElement >> element [

	^ element
]

{ #category : #accessing }
SpS2cUpdateElement >> element: anObject [

	element := anObject
]

{ #category : #accessing }
SpS2cUpdateElement >> executeInResponseContext: rc [

	self element
		requestContext: rc;
		update
]
