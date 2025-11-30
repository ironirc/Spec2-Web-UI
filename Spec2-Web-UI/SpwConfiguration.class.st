Class {
	#name : 'SpwConfiguration',
	#superclass : 'SpApplicationConfiguration',
	#instVars : [
		'styleSheet'
	],
	#category : 'Spec2-Web-UI-specBackEnd',
	#package : 'Spec2-Web-UI',
	#tag : 'specBackEnd'
}

{ #category : 'testing' }
SpwConfiguration class >> isAvailableFor: aBackend inApplication: anApplication [

	^ aBackend name = #WebUI
]

{ #category : 'styling' }
SpwConfiguration >> addStyleSheet: aStylesheet [

	styleSheet := self styleSheet, aStylesheet
]

{ #category : 'styling' }
SpwConfiguration >> addStyleSheetFromString: aString [

	self addStyleSheet: (SpStyleVariableSTONReader fromString: aString)
]

{ #category : 'configuring' }
SpwConfiguration >> configure: anApplication [

	super configure: anApplication.
	self styleSheet "Initialize stylesheet"
]

{ #category : 'private - factory' }
SpwConfiguration >> newStyleSheet [

	^ SpStyle defaultStyleSheet copy
]

{ #category : 'styling' }
SpwConfiguration >> styleSheet [
	"Define the default styleSheet to use in your application. You can override this and add your 
	 own application dependent styles (and you can compose them, see `SpStyle`).
	
	```Smalltalk
	^ SpStyle defaultStyleSheet copy
	```
	"
	
	^ styleSheet ifNil: [ styleSheet := self newStyleSheet ]
]

{ #category : 'styling' }
SpwConfiguration >> styleSheet: aStyleSheet [

	styleSheet := aStyleSheet
]
