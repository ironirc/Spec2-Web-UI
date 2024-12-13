Class {
	#name : 'SpwLabel_WC',
	#superclass : 'SpwAbstract_WC',
	#instVars : [
		'label'
	],
	#category : 'Spec2-Web-UI-Adapters-WebComponents',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'WebComponents'
}

{ #category : 'constants' }
SpwLabel_WC class >> tagName [

	^ 'spw-label'
]

{ #category : 'accessing' }
SpwLabel_WC >> label [

	^ label
]

{ #category : 'accessing' }
SpwLabel_WC >> label: anObject [

	label := anObject.
	self render
]

{ #category : 'rendering' }
SpwLabel_WC >> renderOn: x [

	"x button: [ :el |
		x _style: {
				('height' -> '100%').
				('width' -> '100%').
				('box-sizing' -> 'border-box') }.
		button := el ]"
	x span: (self label ifNil: [ '' ])
]
