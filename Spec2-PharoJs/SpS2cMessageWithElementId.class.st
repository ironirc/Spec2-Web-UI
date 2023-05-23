Class {
	#name : #SpS2cMessageWithElementId,
	#superclass : #SpS2cMessage,
	#instVars : [
		'elementId'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cMessageWithElementId >> element [

	^ self document getElementById: elementId
]

{ #category : #accessing }
SpS2cMessageWithElementId >> elementId [

	^ elementId
]

{ #category : #accessing }
SpS2cMessageWithElementId >> elementId: anObject [

	elementId := anObject
]
