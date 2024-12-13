Class {
	#name : 'SpC2sFetchTableData',
	#superclass : 'SpC2sEvent',
	#instVars : [
		'page',
		'pageSize'
	],
	#category : 'Spec2-Web-UI-clientToServerMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'clientToServerMessages'
}

{ #category : 'private' }
SpC2sFetchTableData >> dispatchToSpecAdaptor: ad requestContext: rc [

	| msg startIdx endIdx pageObjects |
	startIdx := 1 + (page - 1 * pageSize).
	endIdx := startIdx + pageSize - 1.
	msg := SpS2cFetchTableDataResponse new.
	pageObjects := ad model items
		               copyFrom: startIdx
		               to: (endIdx min: ad model items size).
	msg data: (pageObjects withIndexCollect: [ :object :idx | 
			 ad convertObjectToArrayForTabulator: object id: startIdx - 1 + idx ]).
	msg currentPage: page.
	msg lastPage: (ad model items size / pageSize) ceiling.
	rc sendResponseMessage: msg
]

{ #category : 'accessing' }
SpC2sFetchTableData >> page [

	^ page
]

{ #category : 'accessing' }
SpC2sFetchTableData >> page: anObject [

	page := anObject
]

{ #category : 'accessing' }
SpC2sFetchTableData >> pageSize [

	^ pageSize
]

{ #category : 'accessing' }
SpC2sFetchTableData >> pageSize: anObject [

	pageSize := anObject
]
