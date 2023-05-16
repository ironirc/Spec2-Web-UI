Class {
	#name : #SpC2sEvent,
	#superclass : #SpC2sMessage,
	#instVars : [
		'sourceId'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #'as yet unclassified' }
SpC2sEvent class >> forEventName: aName [

	self subclasses do: [ :e | e eventName = aName ifTrue: [ ^e ] ].
	^self error: 'Event class not found for name: ' , aName
]

{ #category : #'as yet unclassified' }
SpC2sEvent class >> newForNativeEvent: e [

	^ self new
		  initializeWithNativeEvent: e;
		  yourself
]

{ #category : #private }
SpC2sEvent >> dispatchToSpecAdaptor: ad [

	ad
		perform:
		('handle' , self class eventName capitalized , ':') asSymbol
		with: self
]

{ #category : #initialization }
SpC2sEvent >> initializeWithNativeEvent: e [


]

{ #category : #private }
SpC2sEvent >> respondForRequestContext: rc [

	

	<pharoJsSkip>
	SpPharoJsApp1 current windows do: [ :wind | 
		wind
			traversePresentersDo: [ :p | 
				p adapter widget = sourceId ifTrue: [ 
					self dispatchToSpecAdaptor: p adapter ] ]
			excluding: Set new ]
]

{ #category : #accessing }
SpC2sEvent >> sourceId [

	^ sourceId
]

{ #category : #accessing }
SpC2sEvent >> sourceId: anObject [

	sourceId := anObject
]
