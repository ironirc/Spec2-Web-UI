Class {
	#name : #SpPharoJsPlaygroundContents,
	#superclass : #Object,
	#category : #'Spec2-PharoJs-AdHoc'
}

{ #category : #'as yet unclassified' }
SpPharoJsPlaygroundContents >> stuff20230516 [

	| app |
	app := SpPharoJsApp1 current.
	app reset.
	app windows.
	app windows any presenter
]
