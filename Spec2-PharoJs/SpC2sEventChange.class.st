Class {
	#name : #SpC2sEventChange,
	#superclass : #SpC2sEvent,
	#instVars : [
		'newValue'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpC2sEventChange class >> eventName [ 

	^'change'
]

{ #category : #initialization }
SpC2sEventChange >> initializeWithNativeEvent: e [
	super initializeWithNativeEvent: e.
	
	newValue := e target value

	
]

{ #category : #accessing }
SpC2sEventChange >> newValue [

	^ newValue
]

{ #category : #accessing }
SpC2sEventChange >> newValue: anObject [

	newValue := anObject
]
