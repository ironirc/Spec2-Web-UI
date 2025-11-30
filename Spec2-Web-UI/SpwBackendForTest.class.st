Class {
	#name : 'SpwBackendForTest',
	#superclass : 'SpAbstractBackendForTest',
	#instVars : [
		'app'
	],
	#category : 'Spec2-Web-UI-tests',
	#package : 'Spec2-Web-UI',
	#tag : 'tests'
}

{ #category : 'accessing' }
SpwBackendForTest >> assertHasHeader: anAdapter [ 
	
	self assert: anAdapter innerWidget isHeadersVisible
]

{ #category : 'asserting' }
SpwBackendForTest >> assertIcon: aGtkImage equals: aForm [ 
	
	(aForm isNil and: [ aGtkImage isNil ]) ifTrue: [ ^ self ].
	
	"I can only test if the image is nil and the form is nil or not"
	self assert: (aForm isNotNil or: [(aGtkImage isNil or: [ aGtkImage isNull])]).
	self assert: (aGtkImage isNotNil and: [ aGtkImage isNull not])
	
]

{ #category : 'as yet unclassified' }
SpwBackendForTest >> assertImage: aGtkImage equals: aForm [ 
	
	| pixbuf |
	pixbuf := aGtkImage asGdkPixbuf.
	(aForm isNil and: [ pixbuf isNull ]) ifTrue: [ ^ self ].

	self assert: pixbuf isNull not.	
	self assert: pixbuf width = aForm width.
	self assert: pixbuf height = aForm height.
	self assert: pixbuf depth = aForm depth.

]

{ #category : 'asserting' }
SpwBackendForTest >> assertList: aTreeTableAdapter displayItems: aCollection [ 
	| iter |
	
	iter := aTreeTableAdapter innerWidget model iteratorFromPath: (GtkTreePath newFromArray: #(1)).
	aCollection do: [ :aValue |  
		self assert: (iter stringAt: 0) = aValue.
		iter next ]
]

{ #category : 'asserting' }
SpwBackendForTest >> assertListHeaderOf: aGtkTreeView equals: aCollection [

	self assert: (aGtkTreeView columns collect: [ :c | c title ]) asArray = aCollection asArray
	
]

{ #category : 'testing' }
SpwBackendForTest >> canChangeFonts [
	
	^ false
]

{ #category : 'emulating' }
SpwBackendForTest >> clickFirstRowAndColumn: anAdapter [ 
	| path |
	path := (GtkTreePath newFromArray: #(1)) autoRelease.	
	anAdapter innerWidgetDo: [ :w |
		w 
			activateRow: path 
			column: w columns first ]
]

{ #category : 'accessing' }
SpwBackendForTest >> denyHasHeader: anAdapter [ 
	
	self assert: anAdapter innerWidget isHeadersVisible not
]

{ #category : 'simulating' }
SpwBackendForTest >> doubleClickFirstRowAndColumn: anAdapter [ 
	
	self clickFirstRowAndColumn: anAdapter
]

{ #category : 'testing' }
SpwBackendForTest >> isGtkBackend [

	^ true
]

{ #category : 'running' }
SpwBackendForTest >> openInstanceOf: aTest [ 
		
	aTest window ifNil: [ 
		aTest presenter application: app.
		aTest window: aTest presenter open ].

]

{ #category : 'running' }
SpwBackendForTest >> runTest: aBlockClosure [ 
		
	app := SpApplication new.
	app useBackend: #WebUI.
	aBlockClosure value
]
