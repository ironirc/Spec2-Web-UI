Class {
	#name : #'SpwButton_WC',
	#superclass : #PjWebComponent,
	#instVars : [
		'button'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #constants }
SpwButton_WC class >> tagName [

	^ 'spw-button'
]

{ #category : #rendering }
SpwButton_WC >> renderOn: x [

	"x button: [ :el |
		x _style: {
				('height' -> '100%').
				('width' -> '100%').
				('box-sizing' -> 'border-box') }.
		button := el ]"
]
