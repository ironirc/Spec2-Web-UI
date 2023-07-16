Class {
	#name : #SpS2cFetchTableDataResponse,
	#superclass : #SpS2cMessage,
	#instVars : [
		'data',
		'currentPage',
		'lastPage'
	],
	#category : #'Spec2-Web-UI-serverToClientMessages'
}

{ #category : #accessing }
SpS2cFetchTableDataResponse >> currentPage [

	^ currentPage
]

{ #category : #accessing }
SpS2cFetchTableDataResponse >> currentPage: anObject [

	currentPage := anObject
]

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

	^ lastPage
]

{ #category : #accessing }
SpS2cFetchTableDataResponse >> lastPage: anObject [

	lastPage := anObject
]
