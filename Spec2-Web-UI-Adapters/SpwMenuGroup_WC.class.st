Class {
	#name : #'SpwMenuGroup_WC',
	#superclass : #'SpwAbstract_WC',
	#instVars : [
		'items'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #'as yet unclassified' }
SpwMenuGroup_WC class >> phxJsonClassName [
	^'SpwMenuGroup_WC'
]

{ #category : #'as yet unclassified' }
SpwMenuGroup_WC class >> tagName [ 
	^'spw-menu-group'
]
