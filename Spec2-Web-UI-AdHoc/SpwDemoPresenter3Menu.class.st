Class {
	#name : #SpwDemoPresenter3Menu,
	#superclass : #SpPresenter,
	#instVars : [
		'menu'
	],
	#category : #'Spec2-Web-UI-AdHoc'
}

{ #category : #layout }
SpwDemoPresenter3Menu class >> defaultLayout [

	| main  |
	main := SpBoxLayout newTopToBottom.
	main add: #menu.
	^ main
]

{ #category : #initialization }
SpwDemoPresenter3Menu >> initializePresenters [

	menu := self newMenu.
	menu
		addItem: [ :item | item
			name: 'Act1';
			action: [] ];
		addItem: [ :item | item
			name: 'Act2';
			action: [] ]

]
