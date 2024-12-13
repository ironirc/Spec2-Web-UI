Class {
	#name : 'SpwNumberInputField_A',
	#superclass : 'SpwTextInputField_A',
	#category : 'Spec2-Web-UI-Adapters-Adaptors',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'Adaptors'
}

{ #category : 'constants' }
SpwNumberInputField_A class >> remoteWidgetClass [

	^ SpwNumberInputField_RW 
]

{ #category : 'ensure bounds' }
SpwNumberInputField_A >> htmlInputType [

	^'number'
]
