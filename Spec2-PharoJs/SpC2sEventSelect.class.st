Class {
	#name : #SpC2sEventSelect,
	#superclass : #SpC2sWidgetEvent,
	#instVars : [
		'start',
		'end'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpC2sEventSelect class >> eventName [ 

	^'select'
]

{ #category : #accessing }
SpC2sEventSelect >> end [

	^ end
]

{ #category : #accessing }
SpC2sEventSelect >> end: anObject [

	end := anObject
]

{ #category : #initialization }
SpC2sEventSelect >> initializeWithNativeEvent: e [

	super initializeWithNativeEvent: e.
	start := e target selectionStart.
	end := e target selectionEnd
]

{ #category : #accessing }
SpC2sEventSelect >> start [

	^ start
]

{ #category : #accessing }
SpC2sEventSelect >> start: anObject [

	start := anObject
]
