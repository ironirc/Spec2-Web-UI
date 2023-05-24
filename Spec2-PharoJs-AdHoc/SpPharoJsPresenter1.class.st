Class {
	#name : #SpPharoJsPresenter1,
	#superclass : #SpPresenter,
	#instVars : [
		'button2',
		'input1',
		'button1',
		'input2',
		'table',
		'tableButton1'
	],
	#category : #'Spec2-PharoJs-AdHoc'
}

{ #category : #layout }
SpPharoJsPresenter1 class >> defaultLayout [

	| main row bottomRow tableControls |
	main := SpBoxLayout newTopToBottom.
	row := SpBoxLayout newLeftToRight.
	tableControls := SpBoxLayout newTopToBottom.
	tableControls add: #tableButton1.
	bottomRow := SpBoxLayout newLeftToRight.
	bottomRow
		add: #table;
		add: tableControls.
	row
		add: #input2;
		add: #button2.
	main
		add: #button1;
		add: #input1;
		add: row;
		add: bottomRow.
	^ main
]

{ #category : #initialization }
SpPharoJsPresenter1 >> button1Clicked [

	self inspect.
	"input adapter inspect"
]

{ #category : #initialization }
SpPharoJsPresenter1 >> button2Clicked [

	"Color random ifNotNil: [ :clr |" "input enabled: input isEnabled not"
	"	button2 color: clr.
		button2 label: clr asHexString."
		"input text: 'Button changed to color #' , clr asHexString."

	"	button2 label:" "input adapter selectionInterval displayString."
		"	'Selected: ' , input1 selectedText."
			
input2 text: DateAndTime now asString

]

{ #category : #initialization }
SpPharoJsPresenter1 >> connectPresenters [

	button1 action: [ self button1Clicked ].
	button2 action: [ self button2Clicked ].
	input1 whenTextChangedDo: [ :t | self input1TextChangedTo: t ].
	input1 whenSelectionChangedDo: [ :t | self input1SelectionChanged ].
	input2 whenTextChangedDo: [ :t | self input2TextChangedTo: t ].
"	input1 whenSelectionChangedDo: [ :t | self input1SelectionChanged ]	"
		
tableButton1 action: [ self tableButton1Clicked ].
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
		color: Color green lighter.
	table := self newTable.
	table
		addColumn: (SpStringTableColumn title: 'Seq' evaluated: #id);
		addColumn: (SpStringTableColumn title: 'Full name' evaluated: #name);
		items: self tableData.
	tableButton1 := self newButton.
	tableButton1
		label: 'Do something with table';
		color: Color yellow
]

{ #category : #initialization }
SpPharoJsPresenter1 >> input1SelectionChanged [

	button2 label: input1 selectedText.

]

{ #category : #initialization }
SpPharoJsPresenter1 >> input1TextChangedTo: t [

	input2 text: t.
	"input2 takeKeyboardFocus "
]

{ #category : #initialization }
SpPharoJsPresenter1 >> input2TextChangedTo: t [

	input1 text: t.

]

{ #category : #initialization }
SpPharoJsPresenter1 >> tableButton1Clicked [
	table selectIndex: 5
]

{ #category : #initialization }
SpPharoJsPresenter1 >> tableData [

	^ ((1 to: 100) asArray collect: [ :e | 
		  { 
			  ('id' -> e).
			  ('name' -> ('item ' , e printString)) } asJsObject  ]) 
]
