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
SpPharoJsPresenter1 >> connectPresenters [

	button action: [" 
		Color random ifNotNil: [ :clr | 
			button color: clr.
			button label: 'color #' , clr asHexString ] " self inspect].


	button2 action: [ 
		Color random ifNotNil: [ :clr | 
			button2 color: clr.
			button2 label: clr asHexString.
			input text: 'Button changed to color #' , clr asHexString ].
		"input enabled: input isEnabled not" ]
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
