Class {
	#name : 'SpC2sEventInput',
	#superclass : 'SpC2sWidgetEvent',
	#instVars : [
		'newValue'
	],
	#category : 'Spec2-Web-UI-clientToServerMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'clientToServerMessages'
}

{ #category : 'accessing' }
SpC2sEventInput class >> eventName [ 

	^'input'
]

{ #category : 'initialization' }
SpC2sEventInput >> initializeWithNativeEvent: e [
	super initializeWithNativeEvent: e.
	
	newValue := e target value

	
]

{ #category : 'accessing' }
SpC2sEventInput >> newValue [

	^ newValue
]

{ #category : 'accessing' }
SpC2sEventInput >> newValue: anObject [

	newValue := anObject
]
