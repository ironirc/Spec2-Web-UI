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

	^ SpBoxLayout newTopToBottom
		  add: #button;
		  add: #input;
		  add: #button2;
		  yourself
]

{ #category : #initialization }
SpPharoJsPresenter1 >> initializePresenters [

	button := self newButton.
	button
		label: 'Click me';
		color: Color random.
	button action: [ 
		Color random ifNotNil: [ :clr | 
			button color: clr.
			button label: clr asHexString ] ].
	input := self newTextInput.
	input placeholder: 'Type something here...'.
	"	input text: 'Hello world'."
	button2 := self newButton.
	button2
		label: 'Click me2';
		color: Color random.
	button2 action: [ 
		Color random ifNotNil: [ :clr | 
			button2 color: clr.
			button2 label: clr asHexString.
			input text: clr asHexString ] ]
]
