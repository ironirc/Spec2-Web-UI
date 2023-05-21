Class {
	#name : #SpPharoJsPresenter1,
	#superclass : #SpPresenter,
	#instVars : [
		'button',
		'button2',
		'input'
	],
	#category : #'Spec2-PharoJs-AdHoc'
}

{ #category : #layout }
SpPharoJsPresenter1 class >> defaultLayout [

	| main row |
	main := SpBoxLayout newTopToBottom.
	row := SpBoxLayout newLeftToRight.
	row
		add: #input;
		add: #button2.
	main
		add: #button;
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
			input selectedText.

]

{ #category : #initialization }
SpPharoJsPresenter1 >> buttonClicked [

	self inspect.
	input adapter inspect
]

{ #category : #initialization }
SpPharoJsPresenter1 >> connectPresenters [

	button action: [ self buttonClicked ].
	button2 action: [ self button2Clicked ]
]

{ #category : #initialization }
SpPharoJsPresenter1 >> initializePresenters [

	button := self newButton.
	button
		label: 'Inspect presenter';
		color: Color yellow.
	input := self newTextInput.
	input placeholder: 'Type something here...'.
	button2 := self newButton.
	button2
		label: 'Click me2';
		color: Color random
]
