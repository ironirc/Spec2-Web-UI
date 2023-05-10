Class {
	#name : #SpPharoJsPresenter1,
	#superclass : #SpPresenter,
	#instVars : [
		'button'
	],
	#category : #'Spec2-PharoJs-AdHoc'
}

{ #category : #layout }
SpPharoJsPresenter1 class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #button;
		  yourself
]

{ #category : #initialization }
SpPharoJsPresenter1 >> initializePresenters [

	button := self newButton
		          label: 'Click me';
		          color: Color red;
		          yourself
]
