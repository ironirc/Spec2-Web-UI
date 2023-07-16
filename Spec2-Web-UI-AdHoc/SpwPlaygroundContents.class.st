Class {
	#name : #SpwPlaygroundContents,
	#superclass : #Object,
	#category : #'Spec2-Web-UI-AdHoc'
}

{ #category : #'as yet unclassified' }
SpwPlaygroundContents >> stuff20230516 [

	| app |
	app := SpwApp1 new.
	(app new: SpwPresenter1) open.
	SpwPresenter1 new open.
	SpButtonPresenter new open
]
