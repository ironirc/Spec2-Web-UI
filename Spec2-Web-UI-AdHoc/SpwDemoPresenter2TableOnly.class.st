Class {
	#name : 'SpwDemoPresenter2TableOnly',
	#superclass : 'SpPresenter',
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
	#category : 'Spec2-Web-UI-AdHoc',
	#package : 'Spec2-Web-UI-AdHoc'
}

{ #category : 'layout' }
SpwDemoPresenter2TableOnly class >> defaultLayout [

	| main  |
	main := SpBoxLayout newTopToBottom.
	main add: #table.
	^ main
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> button1Clicked [

	self inspect.
	"input adapter inspect"
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> button2Clicked [

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

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> connectPresenters [

"	button1 action: [ self button1Clicked ].
	button2 action: [ self button2Clicked ].
	input1 whenTextChangedDo: [ :t | self input1TextChangedTo: t ].
	input1 whenSelectionChangedDo: [ :t | self input1SelectionChanged ].
	input2 whenTextChangedDo: [ :t | self input2TextChangedTo: t ].
	tableButton1 action: [ self tableButton1Clicked ].
	numberInput1 whenNumberChangedDo: [ :n |
		self numberInput1ChangedToNumber: n ]"
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> initializePresenters [

	button1 := self newButton.
	button1
		label: 'Inspect presenter';
		color: Color yellow.
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
		color: Color green lighter.
	self initializeTable.
	tableButton1 := self newButton.
	tableButton1
		label: 'select some random items';
		color: Color orange lighter
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> initializeTable [

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

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> input1SelectionChanged [
	button2 label: input1 selectedText.

	
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> input1TextChangedTo: t [

	input2 text: t.
	"input2 takeKeyboardFocus "
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> input2TextChangedTo: t [

	input1 text: t.

]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> numberInput1ChangedToNumber: n [

	numberInput2 number: n squared
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> tableButton1Clicked [

	table selectIndexes: ((1 to: 3) collect: [ :e | self tableData size atRandom ])
]

{ #category : 'initialization' }
SpwDemoPresenter2TableOnly >> tableData [

	tableData ifNil: [ tableData := Object withAllSubclasses first: 100 ].
	^ tableData
]
