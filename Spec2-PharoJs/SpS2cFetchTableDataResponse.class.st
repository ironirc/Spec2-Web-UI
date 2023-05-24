Class {
	#name : #SpS2cFetchTableDataResponse,
	#superclass : #SpS2cMessage,
	#instVars : [
		'data',
		'last_page'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cFetchTableDataResponse >> data [

	^ data
]

{ #category : #accessing }
SpS2cFetchTableDataResponse >> data: anObject [

	data := anObject
]

{ #category : #accessing }
SpS2cFetchTableDataResponse >> lastPage [

	^ last_page
]

{ #category : #accessing }
SpS2cFetchTableDataResponse >> lastPage: anObject [

	last_page := anObject
]
