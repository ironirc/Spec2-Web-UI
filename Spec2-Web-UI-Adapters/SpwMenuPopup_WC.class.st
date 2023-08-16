Class {
	#name : #'SpwMenuPopup_WC',
	#superclass : #'SpwAbstract_WC',
	#instVars : [
		'referenceElement'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #'as yet unclassified' }
SpwMenuPopup_WC class >> tagName [

	^ 'spw-menu-popup'
]

{ #category : #rendering }
SpwMenuPopup_WC >> cssText [ 

	^':host {
display: block;
position: absolute;
}'
	
]

{ #category : #rendering }
SpwMenuPopup_WC >> renderOn: x [

	x style: self cssText.
	x slot: [  ]
	
]
