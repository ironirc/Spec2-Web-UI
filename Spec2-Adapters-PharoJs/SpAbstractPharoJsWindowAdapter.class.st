Class {
	#name : #SpAbstractPharoJsWindowAdapter,
	#superclass : #SpAbstractPharoJsAdapter,
	#instVars : [
		'toolbarMorph',
		'menuMorph'
	],
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #testing }
SpAbstractPharoJsWindowAdapter class >> isAbstract [ 

	^self name = #SpAbstractPharoJsWindowAdapter
]

{ #category : #private }
SpAbstractPharoJsWindowAdapter >> add: containerMorph toWindow: aSpecWindow [

	aSpecWindow 
		addMorph: containerMorph 
		fullFrame: LayoutFrame identity
]

{ #category : #private }
SpAbstractPharoJsWindowAdapter >> addContent: aMorph toWindow: aSpecWindow [
	| containerMorph |
	
	containerMorph := self newContainerMorph.
	"containerMorph layoutFrame: aMorph layoutFrame."

	"add all decorations (menu, toolbar and statusbar)"
	self model hasMenu ifTrue: [ self addMenuTo: containerMorph ].

	self setToolbarTo: containerMorph.

	"Register for changes in the toolbar"
	self model whenToolbarChangedDo: [ self setToolbarTo: containerMorph ].

	"containerMorph addMorphBack: aMorph." containerMorph children add: aMorph.
"	aMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	self model hasStatusBar ifTrue: [ self addStatusBarTo: containerMorph ]."
	
	"self add: containerMorph toWindow: aSpecWindow"
	aSpecWindow children add: containerMorph
]

{ #category : #private }
SpAbstractPharoJsWindowAdapter >> addMenuTo: aMorph [
	
	menuMorph := self model menu build.
	aMorph addMorphBack: menuMorph.	
	menuMorph
		hResizing: #spaceFill;
		vResizing: #rigid
]

{ #category : #private }
SpAbstractPharoJsWindowAdapter >> addStatusBarTo: aMorph [

	| statusBarMorph |
	statusBarMorph := self model statusBar build.
	aMorph addMorphBack: statusBarMorph.
	statusBarMorph
		hResizing: #spaceFill;
		vResizing: #rigid
]

{ #category : #private }
SpAbstractPharoJsWindowAdapter >> newContainerMorph [

"	^ Morph new
		color: Color transparent;
		layoutPolicy: TableLayout new;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		listDirection: #topToBottom;
		yourself"
		
	^ SpjRemoteElement new
		  creatorMethod: thisContext method printString;
		  oldMorphClass: Morph name;
		  description: 'lots of properties skipped!!!';
		  "ownerAdapter: self;"
		  yourself
]

{ #category : #private }
SpAbstractPharoJsWindowAdapter >> setToolbarTo: aMorph [
	| newToolbarMorph toolbarPresenter |
	
	self model hasToolbar 
		ifFalse: [
			toolbarMorph ifNotNil: [ 
				aMorph removeMorph: toolbarMorph.
				toolbarMorph := nil.  ].
			^ self ].
	
	toolbarPresenter := self presenter toolbar.
	newToolbarMorph := toolbarPresenter build.
	toolbarPresenter adapter applyStyle.
	newToolbarMorph
		hResizing: #spaceFill;
		vResizing: #rigid.
	
	"If we have a toolbar morph, we replace with the new one"
	toolbarMorph 
		ifNotNil: [ aMorph replaceSubmorph: toolbarMorph by: newToolbarMorph ]
		ifNil: [	
			menuMorph 
				ifNotNil: [ aMorph addMorph: newToolbarMorph after: menuMorph ]
				ifNil: [ aMorph addMorph: newToolbarMorph ] ].
		
	toolbarMorph := newToolbarMorph

]
