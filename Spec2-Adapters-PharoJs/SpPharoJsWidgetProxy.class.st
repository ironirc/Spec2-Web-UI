Class {
	#name : #SpPharoJsWidgetProxy,
	#superclass : #Object,
	#instVars : [
		'id',
		'adaptor'
	],
	#category : #'Spec2-Adapters-PharoJs-Table'
}

{ #category : #accessing }
SpPharoJsWidgetProxy >> adaptor [

	^ adaptor
]

{ #category : #accessing }
SpPharoJsWidgetProxy >> adaptor: anObject [

	adaptor := anObject
]

{ #category : #accessing }
SpPharoJsWidgetProxy >> id [

	^ id
]

{ #category : #accessing }
SpPharoJsWidgetProxy >> id: anObject [

	id := anObject
]
