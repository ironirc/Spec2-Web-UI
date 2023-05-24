Class {
	#name : #SpC2sFetchTableData,
	#superclass : #SpC2sEvent,
	#instVars : [
		'page',
		'pageSize'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #private }
SpC2sFetchTableData >> dispatchToSpecAdaptor: ad requestContext: rc [

	| msg startIdx endIdx |
	startIdx := 1 + (page - 1 * pageSize).
	endIdx := startIdx + pageSize - 1.
	msg := SpS2cFetchTableDataResponse new.
	msg data: (ad model items
			 copyFrom: startIdx
			 to: (endIdx min: ad model items size)).
	msg lastPage: (ad model items size / pageSize) ceiling.
	rc sendResponseMessage: msg
]

{ #category : #accessing }
SpC2sFetchTableData >> page [

	^ page
]

{ #category : #accessing }
SpC2sFetchTableData >> page: anObject [

	page := anObject
]

{ #category : #accessing }
SpC2sFetchTableData >> pageSize [

	^ pageSize
]

{ #category : #accessing }
SpC2sFetchTableData >> pageSize: anObject [

	pageSize := anObject
]
