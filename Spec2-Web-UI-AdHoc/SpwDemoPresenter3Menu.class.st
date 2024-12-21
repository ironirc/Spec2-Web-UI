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
SpwDemoPresenter3Menu >> initializePresenters [

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
	label := self newLabel.
	label label: 'label1'
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
