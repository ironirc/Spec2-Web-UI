Class {
	#name : #SpStcmAddDivTest,
	#superclass : #PhxSpaServerToClientMessage,
	#instVars : [
		'message'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #private }
SpStcmAddDivTest >> executeInResponseContext: rc [

	" co logLine: 'Log: ' , self message"

	| x |
	x := PjDomBuilderReactive newOnElement: self body.
	x div: 'Hello world: ' , (message ifNil: [ '' ]) , ' browser: '
		, Time millisecondClockValue rounded printString
]

{ #category : #accessing }
SpStcmAddDivTest >> message [
	^ message
]

{ #category : #accessing }
SpStcmAddDivTest >> message: anObject [
	message := anObject
]
