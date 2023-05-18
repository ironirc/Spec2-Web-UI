Class {
	#name : #SpPharoJsLayoutAdapter,
	#superclass : #SpAbstractPharoJsAdapter,
	#instVars : [
		'layout'
	],
	#category : #'Spec2-Adapters-PharoJs-Layout'
}

{ #category : #accessing }
SpPharoJsLayoutAdapter >> adapter [
	
	^ nil
]

{ #category : #accessing }
SpPharoJsLayoutAdapter >> add: aPresenter constraints: constraints [
 
	aPresenter owner: self model. 
	self widgetDo: [ :aPanel |
		self 
			basicAdd: aPresenter
			constraints: constraints 
			to: aPanel ]
]

{ #category : #private }
SpPharoJsLayoutAdapter >> addConstraints: constraints toChild: childMorph [

	self subclassResponsibility
]

{ #category : #initialization }
SpPharoJsLayoutAdapter >> addKeyBindingsTo: aMorph [
	"This is called before the layout actually exists. 
	 Skipping it."
	
]

{ #category : #private }
SpPharoJsLayoutAdapter >> applyChildrenAlignmentTo: childMorph constraints: constraints [
	"When it applies (like the case of SpGridLayout), widgets may want to configure alignment 
	 here."
	
	^ childMorph
]

{ #category : #styling }
SpPharoJsLayoutAdapter >> applyStyle: aPresenter to: aMorph [
	self flag: #TODO. "This is a HACK, to apply styles just when I'm using new layouts 
	(otherwise, it interferes on how the old layout is displayed). 
	 Of course, this needs to be applied where it belongs, but for now we need to keep 
	 it this way :("
	
	aPresenter adapter ifNil: [ ^ self ].
	aPresenter adapter applyStyle: aMorph
]

{ #category : #private }
SpPharoJsLayoutAdapter >> basicAdd: aPresenter constraints: constraints to: aPanel [ 

	self subclassResponsibility
]

{ #category : #building }
SpPharoJsLayoutAdapter >> build [
	
	^ self widget
]

{ #category : #private }
SpPharoJsLayoutAdapter >> buildMorph: aPresenter constraints: constraints [

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
SpPharoJsLayoutAdapter >> buildWidget [

	^ nil
]

{ #category : #building }
SpPharoJsLayoutAdapter >> buildWithLayout: aSpecLayout [

	^ self build
]

{ #category : #building }
SpPharoJsLayoutAdapter >> buildWithSelector: aSelector [

	^ self build
]

{ #category : #accessing }
SpPharoJsLayoutAdapter >> children [

	^ self subclassResponsibility
]

{ #category : #testing }
SpPharoJsLayoutAdapter >> isEmpty [

	^ self children isEmpty
]

{ #category : #testing }
SpPharoJsLayoutAdapter >> isSpLayout [

	^ true
]

{ #category : #accessing }
SpPharoJsLayoutAdapter >> layout [

	^ layout
]

{ #category : #protocol }
SpPharoJsLayoutAdapter >> layout: aLayout [

	"Basic apply visibility to the widget.
	This call is here because layouts and widgets work differently"
"	self widget presenter: self presenter."
	"self applyVisibility.
	self applyStyle.
	self addKeyBindingsTo: self widget.
	self addEventsTo: self widget."
]

{ #category : #factory }
SpPharoJsLayoutAdapter >> newPanel [

	^ self newPanelWith: TableLayout new
]

{ #category : #factory }
SpPharoJsLayoutAdapter >> newPanelWith: aBlock [

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

	| id msg |
	id := self class nextIdString.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: id.
	msg tag: 'div'.
	msg styles: { 
			('background-color' -> '#800').
			('display' -> 'flex').
			('flex-grow' -> 1) }.
	msg attributes: { ('method' -> thisContext method printString) }.
	aBlock value: msg.
	self sendUpdateMessageToClient: msg.
	^ id
]

{ #category : #initialization }
SpPharoJsLayoutAdapter >> replaceLayoutWith: aLayout [ 

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
SpPharoJsLayoutAdapter >> takeKeyboardFocus [

	self presenter presentersInFocusOrder 
		ifNotEmpty: [ :presenters | presenters first takeKeyboardFocus ]
]

{ #category : #updating }
SpPharoJsLayoutAdapter >> updateBorderWidth [

	widget borderWidth: layout borderWidth
]
