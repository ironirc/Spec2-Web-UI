Class {
	#name : #'SpwButton_WC',
	#superclass : #'SpwAbstract_WC',
	#instVars : [
		'label'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #constants }
SpwButton_WC class >> tagName [

	^ 'spw-button'
]

{ #category : #accessing }
SpwButton_WC >> label [

	^ label
]

{ #category : #accessing }
SpwButton_WC >> label: anObject [

	label := anObject.
	self render.
]

{ #category : #rendering }
SpwButton_WC >> renderOn: x [
	self label ifNotNil: [ x << self label ]
	
	
]
