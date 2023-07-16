Class {
	#name : #SpPharoJsPlaygroundContents,
	#superclass : #Object,
	#category : #'Spec2-Web-UI-AdHoc'
}

{ #category : #'as yet unclassified' }
SpPharoJsPlaygroundContents >> stuff20230516 [

	| app |
	app := SpPharoJsApp1 new.
	(app new: SpPharoJsPresenter1) open.
	SpPharoJsPresenter1 new open.
	SpButtonPresenter new open
]
