Class {
	#name : #SpC2sEvent,
	#superclass : #SpC2sMessage,
	#instVars : [
		'sourceId'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpC2sEvent >> respondForRequestContext: rc [

	<pharoJsSkip>
	Transcript
		cr;
		show: 'Event received from ' , self sourceId.
	SpPharoJsApp1 current windows do: [ :wind | 
		wind
			traversePresentersDo: [ :p | 
			p adapter widget = sourceId ifTrue: [ p action value ] ]
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
