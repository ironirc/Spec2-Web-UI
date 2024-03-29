Class {
	#name : #SpwDemoPresenter1,
	#superclass : #SpPresenter,
	#instVars : [
		'button2',
		'input1',
		'button1',
		'input2',
		'table',
		'tableButton1',
		'label1',
		'tableData',
		'numberInput1',
		'numberInput2'
	],
	#category : #'Spec2-Web-UI-AdHoc'
}

{ #category : #layout }
SpwDemoPresenter1 class >> defaultLayout [

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
		add: #label1;
		add: #numberInput1;
		add: #numberInput2;
		add: #input1;
		add: row;
		add: bottomRow.
	^ main
]

{ #category : #initialization }
SpwDemoPresenter1 >> button1Clicked [

	self inspect.
	"input adapter inspect"
]

{ #category : #initialization }
SpwDemoPresenter1 >> button2Clicked [

	"Color random ifNotNil: [ :clr |"

	"input enabled: input isEnabled not"

	"	button2 color: clr.
		button2 label: clr asHexString."

	"input text: 'Button changed to color #' , clr asHexString."

	"	button2 label:"

	"input adapter selectionInterval displayString."

	"	'Selected: ' , input1 selectedText."

	input2 text: DateAndTime now asString.
	input2 color: Color random muchLighter 
]

{ #category : #initialization }
SpwDemoPresenter1 >> connectPresenters [

	button1 action: [ self button1Clicked ].
	button2 action: [ self button2Clicked ].
	input1 whenTextChangedDo: [ :t | self input1TextChangedTo: t ].
	input1 whenSelectionChangedDo: [ :t | self input1SelectionChanged ].
	input2 whenTextChangedDo: [ :t | self input2TextChangedTo: t ].
	tableButton1 action: [ self tableButton1Clicked ].
	numberInput1 whenNumberChangedDo: [ :n |
		self numberInput1ChangedToNumber: n ]
]

{ #category : #initialization }
SpwDemoPresenter1 >> initializePresenters [

	button1 := self newButton.
	button1
		label: 'Inspect presenter';
		iconName: #pharo;
		color: Color yellow;
		help:
			'opens an inspector on the presenter of this window (in Pharo-morphic world)'.
	label1 := self newLabel.
	label1 label: 'label1'.
	input1 := self newTextInput.
	input1 placeholder: 'input1 ... '.
	input2 := self newTextInput.
	input2 placeholder: 'input2 ...'.
	numberInput1 := self newNumberInput.
	self whenDisplayDo: [ numberInput1 number: 42 ].
	numberInput2 := self newNumberInput
		                beFloat;
		                digits: 3;
		                climbRate: 0.005;
		                minimum: 10.005;
		                maximum: 20.05.
	button2 := self newButton.
	button2
		label: 'Click me2';
		iconName: #home;
		color: Color green lighter;
		help: 'update both inputs with current date and time'.
	self initializeTable.
	tableButton1 := self newButton.
	tableButton1
		label: 'select some random items of the table';
		color: Color orange lighter
]

{ #category : #initialization }
SpwDemoPresenter1 >> initializeTable [

	table := self newTable.
	table
		addColumn: (SpIndexTableColumn title: 'ID' evaluated: #id);
		addColumn: ((SpImageTableColumn
				  title: 'Icon'
				  evaluated: [ :aClass | self iconNamed: aClass systemIconName ])
				 width: 50;
				 displayAlignment: [ :each | SpColumnAlignment center ];
				 yourself);
		addColumn: (SpStringTableColumn title: 'Class' evaluated: #name);
		addColumn: ((SpStringTableColumn
				  title: 'Methods'
				  evaluated: [ :e | e numberOfMethods displayString ])
				 displayAlignment: [ :each | SpColumnAlignment right ];
				 yourself);
		addColumn: ((SpStringTableColumn
				  title: 'Instvars'
				  evaluated: [ :e | e instVarNames size displayString ])
				 displayAlignment: [ :each | SpColumnAlignment right ];
				 yourself);
		addColumn: ((SpCheckBoxTableColumn
				  title: 'has vars'
				  evaluated: [ :e | e instVarNames size > 0 ])
				 displayAlignment: [ :each | SpColumnAlignment center ];
				 yourself);
		items: self tableData;
		beMultipleSelection
]

{ #category : #initialization }
SpwDemoPresenter1 >> input1SelectionChanged [
	button2 label: input1 selectedText.

	
]

{ #category : #initialization }
SpwDemoPresenter1 >> input1TextChangedTo: t [

	input2 text: t.
	"input2 takeKeyboardFocus "
]

{ #category : #initialization }
SpwDemoPresenter1 >> input2TextChangedTo: t [

	input1 text: t.

]

{ #category : #initialization }
SpwDemoPresenter1 >> numberInput1ChangedToNumber: n [

	numberInput2 number: n squared
]

{ #category : #initialization }
SpwDemoPresenter1 >> tableButton1Clicked [

	table selectIndexes: ((1 to: 20) collect: [ :e | self tableData size atRandom ])
]

{ #category : #initialization }
SpwDemoPresenter1 >> tableData [

	tableData ifNil: [ tableData := Object withAllSubclasses first: 100 ].
	^ tableData
]
