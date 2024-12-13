Class {
	#name : 'SpwBox_A',
	#superclass : 'SpwLayout_A',
	#instVars : [
		'startPanel',
		'endPanel'
	],
	#classVars : [
		'Experimental'
	],
	#category : 'Spec2-Web-UI-Adapters-Layout',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'Layout'
}

{ #category : 'experiment-toggle' }
SpwBox_A class >> useExperimentalWhile: aBlock [

	Experimental := true.
	aBlock ensure: [ Experimental := false ]
]

{ #category : 'factory' }
SpwBox_A >> add: aPresenter [
 
	self add: aPresenter constraints: SpBoxConstraints new
]

{ #category : 'adding' }
SpwBox_A >> add: aPresenter constraints: constraints [

	super add: aPresenter constraints: constraints
]

{ #category : 'private' }
SpwBox_A >> addConstraints: constraints toChild: childMorph [
	"Adds constraits by child"
	| theMorph |
	
	theMorph := self addPadding: constraints padding toMorph: childMorph.
	constraints isExpand 
		ifTrue: [ 
			"if is not 'fill', in fact I need to pad it with another (since it 'expands', 
			 but does not 'fills')"
			constraints isFill ifFalse: [ 
				theMorph
					hResizing: #rigid;
					vResizing: #rigid.
				theMorph := self newPanel
					addMorphBack: theMorph;
					yourself ]. 
			"Set to fill"
			"theMorph 
				hResizing: #spaceFill;
				vResizing: #spaceFill" ]
		ifFalse: [
			"Set morph to stay rigid"
			layout direction setRigidityOfNonExpandedMorph: theMorph.
			constraints width ifNotNil: [ :w | theMorph width: w ].
			constraints height ifNotNil: [ :h | theMorph height: h ] ].
	
	^ theMorph 
]

{ #category : 'private' }
SpwBox_A >> addHorizontalPadding: aNumber toMorph: aMorph [

	^ self newWrapMorph
		  hResizing: aMorph hResizing;
		  vResizing: aMorph vResizing;
		  width: aMorph width + (aNumber * 2);
		  height: aMorph height;
		  addMorph: (aMorph
			   hResizing: #spaceFill;
			   vResizing: #spaceFill;
			   yourself)
		  fullFrame: (LayoutFrame identity
			   leftOffset: aNumber;
			   rightOffset: aNumber negated);
		  yourself
]

{ #category : 'private' }
SpwBox_A >> addPadding: aNumber toMorph: aMorph [
	
	aNumber = 0 ifTrue: [ ^ aMorph ].
	
	^ layout direction 
		addPadding: aNumber 
		toMorph: aMorph
		into: self
]

{ #category : 'private' }
SpwBox_A >> addVerticalPadding: aNumber toMorph: aMorph [

	^ self newWrapMorph
		  hResizing: aMorph hResizing;
		  vResizing: aMorph vResizing;
		  width: aMorph width;
		  height: aMorph height + (aNumber * 2);
		  addMorph: (aMorph
			   hResizing: #spaceFill;
			   vResizing: #spaceFill;
			   yourself)
		  fullFrame: (LayoutFrame identity
			   topOffset: aNumber;
			   bottomOffset: aNumber negated);
		  yourself
]

{ #category : 'private' }
SpwBox_A >> applyAlignmentTo: aWidget [

	layout isVertical
		ifTrue: [ 
			layout vAlign ifNotNil: [ :align | 
				startPanel vResizing: #shrinkWrap.
				aWidget listCentering: align asMorphicAlign ].
			layout hAlign ifNotNil: [ :align | 
				startPanel hResizing: #shrinkWrap.
				aWidget wrapCentering: align asMorphicAlign.
				aWidget cellPositioning: align asMorphicAlign ] ]
		ifFalse: [ 
			layout vAlign ifNotNil: [ :align | 
				startPanel vResizing: #shrinkWrap.
				aWidget wrapCentering: align asMorphicAlign.
				aWidget cellPositioning: align asMorphicAlign ].
			layout hAlign ifNotNil: [ :align | 
				startPanel hResizing: #shrinkWrap.
				aWidget listCentering: align asMorphicAlign ] ].

	^ aWidget
]

{ #category : 'private' }
SpwBox_A >> applyAlignmentToChild: aWidget [

	layout vAlign 
		ifNotNil: [ aWidget vResizing: #rigid ].
	layout hAlign 
		ifNotNil: [ aWidget hResizing: #rigid ]

]

{ #category : 'private' }
SpwBox_A >> basicAdd: aPresenter constraints: constraints to: aPanel [

	| childMorph msg |
	childMorph := self buildMorph: aPresenter constraints: constraints.

	self applyAlignmentToChild: childMorph.
	self verifyBoxExtentOf: aPanel withChild: childMorph.

	"	constraints isPlacedAtStart
		ifTrue: [ startPanel addMorphBack: childMorph ]
		ifFalse: [ endPanel addMorphBack: childMorph ]."
	"	widget children add: childMorph."
	msg := SpS2cAddElementToParent new.
	msg elementId: childMorph id.
	msg parentId: aPanel id.
	self sendMessageToClient: msg.



	^ childMorph
]

{ #category : 'accessing' }
SpwBox_A >> children [

	^ startPanel submorphs, endPanel submorphs
]

{ #category : 'accessing' }
SpwBox_A >> childrenWidgets [
	
	^ self children
]

{ #category : 'factory' }
SpwBox_A >> layout: aLayout [

	layout := aLayout.
	
	widget ifNil: [
		"build of widget was differed up to here (to know what is the direction)"
		widget := aLayout direction newWidgetOn: self.
	"	widget borderWidth: aLayout borderWidth.
		aLayout hasAlignment 
			ifTrue: [ widget := self applyAlignmentTo: widget ]."
		"the spacing needs to be applied to the inner sub-panels"
		self flag: 'Ivo skipping panels. What is startPanel en endPanel for anyway?'.
	"	{ startPanel. endPanel } 
			do: [ :each | each cellInset: aLayout spacing ]"
		"widget homogeneous: aLayout isHomogeneous" ].

	aLayout whenChildrenAddedDo: [ :ann |
		self
			add: ann child
			constraints: (aLayout constraintsFor: ann child) ].
	
	aLayout whenChildrenRemovedDo: [ :ann |
		self remove: ann child ].
	
	super layout: aLayout
]

{ #category : 'factory' }
SpwBox_A >> newHorizontal [

	^ self newPanelWith: [ :msg | 
		  msg
			  addStyle: 'grid-template-columns'
			  value: (String streamContents: [ :ws | 
					   | pct |
					   pct := 100 / layout children size.
					   layout children do: [ :e | 
						   ws << ' ' << pct displayString << '%' ] ]).
		  msg addStyle: 'grid-template-rows' value: '100%'.
		  msg addStyle: 'height' value: '100%' ]
]

{ #category : 'factory' }
SpwBox_A >> newPanelLayout [

	"^ SpMorphicBoxLayout new
		specLayout: layout;
		yourself"

	"^ SpjRemoteElement new
	
		  oldMorphClass: SpMorphicBoxLayout name;
		  creatorMethod: thisContext method printString;
		description: 'Is probably not a remote element!!! create SpPharoJsBoxLayout instead'
		  yourself"

	
]

{ #category : 'factory' }
SpwBox_A >> newVertical [

	^ self newPanelWith: [ :msg | 
		  msg
			  addStyle: 'grid-template-rows'
			  value: (String streamContents: [ :ws | 
					   | pct |
					   pct := 100 / layout children size.
					   layout children do: [ :e | 
						   ws << ' ' << pct asFloat displayString << '%' ] ]).
		  msg addStyle: 'height' value: '100%' ]
]

{ #category : 'factory' }
SpwBox_A >> newWrapMorph [

	"^ Morph new
		  layoutPolicy: ProportionalLayout new;
		  color: Color transparent;
		  borderColor: Color transparent yourself"
		self halt.
]

{ #category : 'accessing' }
SpwBox_A >> remove: aPresenter [

	| morph |
	morph := aPresenter adapter widget.	
	startPanel removeMorph: morph.
	endPanel removeMorph: morph.
	self verifyBoxExtent
	
]

{ #category : 'accessing' }
SpwBox_A >> removeAll [

	startPanel removeAllMorphs.
	endPanel removeAllMorphs.
	self verifyBoxExtent
]

{ #category : 'factory' }
SpwBox_A >> removeSubWidgets [

	startPanel removeAllMorphs.
	endPanel removeAllMorphs
]

{ #category : 'accessing' }
SpwBox_A >> replace: aPresenter with: otherPresenter [

	| panel oldMorph newMorph |	
	oldMorph := aPresenter adapter widget.
	panel := (startPanel submorphs includes: oldMorph)
		ifTrue: [ startPanel ] 
		ifFalse: [ endPanel ].
	
	newMorph := self 
		buildMorph: otherPresenter 
		constraints: (layout constraintsFor: otherPresenter).

	panel replaceSubmorph: oldMorph by: newMorph
]

{ #category : 'accessing' }
SpwBox_A >> replace: aPresenter with: otherPresenter withConstraints: constraints [

	| panel oldMorph newMorph |	
	oldMorph := aPresenter adapter widget.
	panel := (startPanel submorphs includes: oldMorph)
		ifTrue: [ startPanel ] 
		ifFalse: [ endPanel ].
	
	newMorph := self 
		buildMorph: otherPresenter 
		constraints: constraints.

	panel replaceSubmorph: oldMorph by: newMorph
]

{ #category : 'updating' }
SpwBox_A >> updateSpacing [

	{ startPanel. endPanel } 
			do: [ :each | each cellInset: layout spacing ]
]

{ #category : 'private' }
SpwBox_A >> verifyBoxExtent [

	(startPanel hasSubmorphs not and: [ endPanel hasSubmorphs not ])
		ifTrue: [ widget extent: 0@0 ]
]

{ #category : 'private' }
SpwBox_A >> verifyBoxExtentOf: aPanel withChild: childMorph [
	"| width height |

	width := childMorph width + (widget borderWidth * 2).
	height := childMorph height + (widget borderWidth * 2).

	layout isVertical 
		ifTrue: [ height := height + aPanel height + aPanel cellInset ]
		ifFalse: [ width := width + aPanel width + aPanel cellInset ].
		 
	aPanel extent: (aPanel width max: width)@(aPanel height max: height)"
]
