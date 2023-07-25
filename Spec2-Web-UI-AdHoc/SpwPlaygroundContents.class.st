Class {
	#name : #SpwPlaygroundContents,
	#superclass : #Object,
	#category : #'Spec2-Web-UI-AdHoc'
}

{ #category : #'as yet unclassified' }
SpwPlaygroundContents >> stuff20230516 [

	| app |
	app := SpwDemoApp1 new.
	(app new: SpwDemoPresenter1) open.
	SpwDemoPresenter1 new open.
	SpButtonPresenter new open
]
