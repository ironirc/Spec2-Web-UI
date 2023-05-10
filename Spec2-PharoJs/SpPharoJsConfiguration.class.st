Class {
	#name : #SpPharoJsConfiguration,
	#superclass : #SpApplicationConfiguration,
	#instVars : [
		'styleSheet'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #testing }
SpPharoJsConfiguration class >> isAvailableFor: aBackend inApplication: anApplication [

	^ aBackend name = #PharoJs
]

{ #category : #styling }
SpPharoJsConfiguration >> addStyleSheet: aStylesheet [

	styleSheet := self styleSheet, aStylesheet
]

{ #category : #styling }
SpPharoJsConfiguration >> addStyleSheetFromString: aString [

	self addStyleSheet: (SpStyleVariableSTONReader fromString: aString)
]

{ #category : #configuring }
SpPharoJsConfiguration >> configure: anApplication [

	super configure: anApplication.
	self styleSheet "Initialize stylesheet"
]

{ #category : #'private - factory' }
SpPharoJsConfiguration >> newStyleSheet [

	^ SpStyle defaultStyleSheet copy
]

{ #category : #styling }
SpPharoJsConfiguration >> styleSheet [
	"Define the default styleSheet to use in your application. You can override this and add your 
	 own application dependent styles (and you can compose them, see `SpStyle`).
	
	```Smalltalk
	^ SpStyle defaultStyleSheet copy
	```
	"
	
	^ styleSheet ifNil: [ styleSheet := self newStyleSheet ]
]

{ #category : #styling }
SpPharoJsConfiguration >> styleSheet: aStyleSheet [

	styleSheet := aStyleSheet
]
