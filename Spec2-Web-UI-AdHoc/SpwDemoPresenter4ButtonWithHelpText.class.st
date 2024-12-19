Class {
	#name : 'SpwDemoPresenter4ButtonWithHelpText',
	#superclass : 'SpPresenter',
	#instVars : [
		'button1',
		'label1',
		'menu'
	],
	#category : 'Spec2-Web-UI-AdHoc',
	#package : 'Spec2-Web-UI-AdHoc'
}

{ #category : 'layout' }
SpwDemoPresenter4ButtonWithHelpText class >> defaultLayout [

	| main |
	main := SpBoxLayout newTopToBottom.
	main add: #button1.
	main add: #label1.
	^ main
]

{ #category : 'initialization' }
SpwDemoPresenter4ButtonWithHelpText >> button1Clicked [

	self inspect.
	"input adapter inspect"
]

{ #category : 'initialization' }
SpwDemoPresenter4ButtonWithHelpText >> connectPresenters [


]

{ #category : 'initialization' }
SpwDemoPresenter4ButtonWithHelpText >> initializePresenters [

	menu := self newMenu.
	menu
		addItem: [ :item |
			item
				name: 'Action 1';
				"icon: (self iconNamed: #smallExpertIcon);"action: [
					MorphicUIManager new inform: 'Action 1 clicked' ] ];
		addItem: [ :item |
			item
				name: 'Action 2';
				action: [ MorphicUIManager new inform: 'Action 2 clicked' ] ];
		addItem: [ :item |
			item
				name: 'Other actions';
				subMenu: self subMenu ].
	button1 := self newButton.
	button1
		label: 'Inspect presenter';
		iconName: #pharo;
		color: Color yellow;
		help:
			'opens an inspector on the presenter of this window (in Pharo-morphic world)';
		contextMenu: menu.

	label1 := self newLabel.
	label1 label: 'label1'
]

{ #category : 'initialization' }
SpwDemoPresenter4ButtonWithHelpText >> subMenu [

	| aSubMenu |
	aSubMenu := self newMenu.
	aSubMenu
		addItem: [ :item |
			item
				name: 'Sub Action 1';
				icon: (self iconNamed: #flag);
				action: [ MorphicUIManager new inform: 'Sub Action 1 clicked' ] ];
		addItem: [ :item |
			item
				name: 'Sub Action 2';
				action: [ MorphicUIManager new inform: 'Sub Action 2 clicked' ] ].
	^ aSubMenu
]
