Class {
	#name : 'SpC2sEventChange',
	#superclass : 'SpC2sWidgetEvent',
	#instVars : [
		'newValue'
	],
	#category : 'Spec2-Web-UI-clientToServerMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'clientToServerMessages'
}

{ #category : 'accessing' }
SpC2sEventChange class >> eventName [ 

	^'change'
]

{ #category : 'initialization' }
SpC2sEventChange >> initializeWithNativeEvent: e [
	super initializeWithNativeEvent: e.
	
	newValue := e target value

	
]

{ #category : 'accessing' }
SpC2sEventChange >> newValue [

	^ newValue
]

{ #category : 'accessing' }
SpC2sEventChange >> newValue: anObject [

	newValue := anObject
]
