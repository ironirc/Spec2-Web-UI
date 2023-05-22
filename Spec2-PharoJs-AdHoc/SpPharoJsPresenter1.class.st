Class {
	#name : #SpPharoJsPresenter1,
	#superclass : #SpPresenter,
	#instVars : [
		'button2',
		'input1',
		'button1',
		'input2'
	],
	#category : #'Spec2-PharoJs-AdHoc'
}

{ #category : #layout }
SpPharoJsPresenter1 class >> defaultLayout [

	| main row |
	main := SpBoxLayout newTopToBottom.
	row := SpBoxLayout newLeftToRight.
	row
		add: #input2;
		add: #button2.
	main
		add: #button1;
		add: #input1;
		add: row.
	^ main
]

{ #category : #initialization }
SpPharoJsPresenter1 >> button2Clicked [

	"Color random ifNotNil: [ :clr |" "input enabled: input isEnabled not"
	"	button2 color: clr.
		button2 label: clr asHexString."
		"input text: 'Button changed to color #' , clr asHexString."

		button2 label: "input adapter selectionInterval displayString."
			'Selected: ' , input1 selectedText.

]

{ #category : #initialization }
SpPharoJsPresenter1 >> buttonClicked [

	self inspect.
	"input adapter inspect"
]

{ #category : #initialization }
SpPharoJsPresenter1 >> connectPresenters [

	button1 action: [ self buttonClicked ].
	button2 action: [ self button2Clicked ].
	input1 whenTextChangedDo: [ :t | input2 text: t ].
	input1 whenSelectionChangedDo: [ :t | 
		button2 label: input1 selectedText ]
]

{ #category : #initialization }
SpPharoJsPresenter1 >> initializePresenters [

	button1 := self newButton.
	button1
		label: 'Inspect presenter';
		color: Color yellow.
	input1 := self newTextInput.
	input1 placeholder: 'input1 ... '.
	input2 := self newTextInput.
	input2 placeholder: 'input2 ...'.
	button2 := self newButton.
	button2
		label: 'Click me2';
		color: Color random
]
