Class {
	#name : #'SpwLabel_WC',
	#superclass : #PjWebComponent,
	#instVars : [
		'button'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #constants }
SpwLabel_WC class >> tagName [

	^ 'spw-label'
]

{ #category : #rendering }
SpwLabel_WC >> renderOn: x [

	"x button: [ :el |
		x _style: {
				('height' -> '100%').
				('width' -> '100%').
				('box-sizing' -> 'border-box') }.
		button := el ]"
]
