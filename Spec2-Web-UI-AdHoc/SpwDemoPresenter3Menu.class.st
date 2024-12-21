Class {
	#name : 'SpwDemoPresenter3Menu',
	#superclass : 'SpPresenter',
	#instVars : [
		'menu',
		'label'
	],
	#category : 'Spec2-Web-UI-AdHoc',
	#package : 'Spec2-Web-UI-AdHoc'
}

{ #category : 'initialization' }
SpwDemoPresenter3Menu >> defaultLayout [

	| main  |
	main := SpBoxLayout newLeftToRight.
	main add: menu.
	main add: label.
	^ main
]

{ #category : 'initialization' }
SpwDemoPresenter3Menu >> initializePresenters [

	"icon: (self iconNamed: #smallExpertIcon);"
	self menu.
	label := self newLabel.
	label label: 'label' , PhxRandom randomABC123 
]

{ #category : 'initialization' }
SpwDemoPresenter3Menu >> label: aString [
	label label: aString
]

{ #category : 'initialization' }
SpwDemoPresenter3Menu >> menu [

	menu ifNil: [
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
					subMenu: self subMenu ] ].
	^ menu
]

{ #category : 'initialization' }
SpwDemoPresenter3Menu >> subMenu [

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
