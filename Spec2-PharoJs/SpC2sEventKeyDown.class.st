Class {
	#name : #SpC2sEventKeyDown,
	#superclass : #SpC2sWidgetEvent,
	#instVars : [
		'key',
		'code',
		'altKey',
		'ctrlKey',
		'shiftKey',
		'metaKey',
		'repeat'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpC2sEventKeyDown class >> eventName [ 

	^'keydown'
]

{ #category : #accessing }
SpC2sEventKeyDown >> altKey [

	^ altKey
]

{ #category : #accessing }
SpC2sEventKeyDown >> altKey: anObject [

	altKey := anObject
]

{ #category : #accessing }
SpC2sEventKeyDown >> code [

	^ code
]

{ #category : #accessing }
SpC2sEventKeyDown >> code: anObject [

	code := anObject
]

{ #category : #accessing }
SpC2sEventKeyDown >> ctrlKey [

	^ ctrlKey
]

{ #category : #accessing }
SpC2sEventKeyDown >> ctrlKey: anObject [

	ctrlKey := anObject
]

{ #category : #initialization }
SpC2sEventKeyDown >> initializeWithNativeEvent: e [

	key := e key.
	code := e code.
	altKey := e altKey.
	ctrlKey := e ctrlKey.
	shiftKey := e shiftKey.
	metaKey := e metaKey.
	repeat := e repeat
]

{ #category : #accessing }
SpC2sEventKeyDown >> key [

	^ key
]

{ #category : #accessing }
SpC2sEventKeyDown >> key: anObject [

	key := anObject
]

{ #category : #accessing }
SpC2sEventKeyDown >> metaKey [

	^ metaKey
]

{ #category : #accessing }
SpC2sEventKeyDown >> metaKey: anObject [

	metaKey := anObject
]

{ #category : #accessing }
SpC2sEventKeyDown >> repeat [

	^ repeat
]

{ #category : #accessing }
SpC2sEventKeyDown >> repeat: anObject [

	repeat := anObject
]

{ #category : #accessing }
SpC2sEventKeyDown >> shiftKey [

	^ shiftKey
]

{ #category : #accessing }
SpC2sEventKeyDown >> shiftKey: anObject [

	shiftKey := anObject
]
