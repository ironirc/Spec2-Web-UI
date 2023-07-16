Class {
	#name : #'SpwLayout_A',
	#superclass : #SpwAbstractAdapter,
	#instVars : [
		'layout'
	],
	#category : #'Spec2-Web-UI-Adapters-Layout'
}

{ #category : #accessing }
SpwLayout_A >> adapter [
	
	^ nil
]

{ #category : #accessing }
SpwLayout_A >> add: aPresenter constraints: constraints [
 
	aPresenter owner: self model. 
	self widgetDo: [ :aPanel |
		self 
			basicAdd: aPresenter
			constraints: constraints 
			to: aPanel ]
]

{ #category : #private }
SpwLayout_A >> addConstraints: constraints toChild: childMorph [

	self subclassResponsibility
]

{ #category : #initialization }
SpwLayout_A >> addKeyBindingsTo: aMorph [
	"This is called before the layout actually exists. 
	 Skipping it."
	
]

{ #category : #private }
SpwLayout_A >> applyChildrenAlignmentTo: childMorph constraints: constraints [
	"When it applies (like the case of SpGridLayout), widgets may want to configure alignment 
	 here."
	
	^ childMorph
]

{ #category : #styling }
SpwLayout_A >> applyStyle: aPresenter to: aMorph [
	self flag: #TODO. "This is a HACK, to apply styles just when I'm using new layouts 
	(otherwise, it interferes on how the old layout is displayed). 
	 Of course, this needs to be applied where it belongs, but for now we need to keep 
	 it this way :("
	
	aPresenter adapter ifNil: [ ^ self ].
	aPresenter adapter applyStyle: aMorph
]

{ #category : #private }
SpwLayout_A >> basicAdd: aPresenter constraints: constraints to: aPanel [ 

	self subclassResponsibility
]

{ #category : #building }
SpwLayout_A >> build [
	
	^ self widget
]

{ #category : #private }
SpwLayout_A >> buildMorph: aPresenter constraints: constraints [

	| childMorph |
	childMorph := aPresenter buildWithSelector: constraints spec.
	aPresenter adapter ifNotNil: [ :anAdapter | anAdapter applyStyle ].

	"Add children alignment constraints (if applies)"
	childMorph := self
		              applyChildrenAlignmentTo: childMorph
		              constraints: constraints.
	childMorph := self addConstraints: constraints toChild: childMorph.

	^ childMorph
]

{ #category : #building }
SpwLayout_A >> buildWidget [

	^ nil
]

{ #category : #building }
SpwLayout_A >> buildWithLayout: aSpecLayout [

	^ self build
]

{ #category : #building }
SpwLayout_A >> buildWithSelector: aSelector [

	^ self build
]

{ #category : #accessing }
SpwLayout_A >> children [

	^ self subclassResponsibility
]

{ #category : #testing }
SpwLayout_A >> isEmpty [

	^ self children isEmpty
]

{ #category : #testing }
SpwLayout_A >> isSpLayout [

	^ true
]

{ #category : #accessing }
SpwLayout_A >> layout [

	^ layout
]

{ #category : #protocol }
SpwLayout_A >> layout: aLayout [

	"Basic apply visibility to the widget.
	This call is here because layouts and widgets work differently"
"	self widget presenter: self presenter."
	"self applyVisibility.
	self applyStyle.
	self addKeyBindingsTo: self widget.
	self addEventsTo: self widget."
]

{ #category : #factory }
SpwLayout_A >> newPanel [

	^ self newPanelWith: TableLayout new
]

{ #category : #factory }
SpwLayout_A >> newPanelWith: aBlock [

	"^ Morph new
	  layoutPolicy: aLayout;
	  hResizing: #spaceFill;
	  vResizing: #spaceFill;
	  color: Color transparent;
	  borderColor: Color transparent;
	  clipSubmorphs: true;
	  ""stop being grabbed""beSticky;
	  borderWidth: 0;
	  extent: 0 @ 0;
	  yourself"

	| rw msg |
	rw := self newRemoteWidget.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: rw id.
	msg tag: 'div'.
	msg styles: { 
			('background-color' -> '#EEE').
			('display' -> 'grid').
			"('flex-grow' -> 1) "}.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	aBlock value: msg.
	self sendMessageToClient: msg.
	^ rw
]

{ #category : #initialization }
SpwLayout_A >> replaceLayoutWith: aLayout [ 

	| oldAdapter |
	self widget owner ifNil: [ ^ self ].

	oldAdapter := self.
	self model adapter: (aLayout
		buildAdapterFor: self model
		bindings: self model application adapterBindings).
		
	oldAdapter widget owner 
		replaceSubmorph: oldAdapter widget  
		by: self model adapter widget
]

{ #category : #protocol }
SpwLayout_A >> takeKeyboardFocus [

	self presenter presentersInFocusOrder 
		ifNotEmpty: [ :presenters | presenters first takeKeyboardFocus ]
]

{ #category : #updating }
SpwLayout_A >> updateBorderWidth [

	widget borderWidth: layout borderWidth
]
