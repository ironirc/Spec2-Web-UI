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

	"aSpecWindow 
		addMorph: containerMorph 
		fullFrame: LayoutFrame identity"
		
		| msg |
	msg := SpS2cAddElementToParent new.
	msg elementId: containerMorph.
	msg parentId: aSpecWindow.
	self sendMessageToClient: msg.
]

{ #category : #private }
SpAbstractPharoJsWindowAdapter >> addContent: aMorph toWindow: aSpecWindow [
	| containerMorph msg |
	
	containerMorph := self newContainerMorph.
	"containerMorph layoutFrame: aMorph layoutFrame."

	"add all decorations (menu, toolbar and statusbar)"
	self model hasMenu ifTrue: [ self addMenuTo: containerMorph ].

	self setToolbarTo: containerMorph.

	"Register for changes in the toolbar"
	self model whenToolbarChangedDo: [ self setToolbarTo: containerMorph ].

	msg := SpS2cAddElementToParent new.
	msg elementId: aMorph.
	msg parentId: containerMorph.
	self sendMessageToClient: msg.

	"containerMorph addMorphBack: aMorph." "containerMorph children add: aMorph."
"	aMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	self model hasStatusBar ifTrue: [ self addStatusBarTo: containerMorph ]."
	
	self add: containerMorph toWindow: aSpecWindow
	"aSpecWindow children add: containerMorph"
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

	"^ SpjRemoteElement new
		  creatorMethod: thisContext method printString;
		  oldMorphClass: Morph name;
		  description: 'lots of properties skipped!!!';
		  ""ownerAdapter: self;""
		  yourself"

	| id msg |
	id := self class nextIdString.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: id.
	msg tag: 'div'.
	msg styles: { 
			('background-color' -> '#EEE').
			('height' -> '100vh').
			"('display' -> 'flex')" }.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
	^ id
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
