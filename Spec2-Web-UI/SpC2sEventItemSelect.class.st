Class {
	#name : #SpC2sEventItemSelect,
	#superclass : #SpC2sWidgetEvent,
	#instVars : [
		'itemId'
	],
	#category : #'Spec2-Web-UI-clientToServerMessages'
}

{ #category : #accessing }
SpC2sEventItemSelect class >> eventName [ 

	^'itemselect'
]

{ #category : #accessing }
SpC2sEventItemSelect >> initializeWithNativeEvent: e [

	itemId := e detail itemId.
	
]

{ #category : #accessing }
SpC2sEventItemSelect >> itemId [

	^ itemId
]

{ #category : #accessing }
SpC2sEventItemSelect >> itemId: anObject [

	itemId := anObject
]
