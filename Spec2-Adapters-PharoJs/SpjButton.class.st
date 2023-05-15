Class {
	#name : #SpjButton,
	#superclass : #SpjRemoteElement,
	#instVars : [
		'label',
		'backgroundColor'
	],
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #'instance creation' }
SpjButton class >> new [

	^super new
]

{ #category : #accessing }
SpjButton >> backgroundColor [

	^ backgroundColor
]

{ #category : #accessing }
SpjButton >> backgroundColor: anObject [

	backgroundColor := anObject
]

{ #category : #private }
SpjButton >> ensuredElement [
	^ (self document getElementById: id) ifNil: [ 
		  (self document createElement: 'button')
			  setAttribute: 'id' value: id;
			  addEventListener: #click block: self onClickBlock;
			  yourself ]
]

{ #category : #accessing }
SpjButton >> label [

	^ label
]

{ #category : #accessing }
SpjButton >> label: anObject [

	label := anObject
]

{ #category : #private }
SpjButton >> onClickBlock [

	^ [ 
	  | msg |
	  msg := SpC2sEvent new.
	  msg sourceId: id.
	  self requestContext clientOps sendMessageToServer: msg ]
]

{ #category : #private }
SpjButton >> update [

	| x el |
	el := self ensuredElement.
	x := PjDomBuilder newOnElement: el.
	self updateOn: x.
	(document contains: el) ifFalse: [ document body appendChild: el ]
]

{ #category : #private }
SpjButton >> updateOn: x [

	self backgroundColor ifNotNil: [ :c | 
		x _style: 'background-color' -> ('#' , c) ].
	x _text:  label.
]
