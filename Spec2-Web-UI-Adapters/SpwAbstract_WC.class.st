Class {
	#name : 'SpwAbstract_WC',
	#superclass : 'PjWebComponent',
	#category : 'Spec2-Web-UI-Adapters-WebComponents',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'WebComponents'
}

{ #category : 'testing' }
SpwAbstract_WC class >> isAbstract [

	^ self = SpwAbstract_WC 
]

{ #category : 'rendering' }
SpwAbstract_WC >> initializeWithProperties: props [
	console log: 'initializeWithProperties:' with: props.
	props keysAndValuesDo: [ :k :v | self perform: k , ':' with: v ]
]

{ #category : 'testing' }
SpwAbstract_WC >> isVisible [

	self style display = 'none' ifTrue: [ ^ false ].
	self style visibility = 'hidden' ifTrue: [ ^ false ].
	^ true
]
