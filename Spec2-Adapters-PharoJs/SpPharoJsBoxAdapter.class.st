Class {
	#name : #SpPharoJsBoxAdapter,
	#superclass : #SpPharoJsLayoutAdapter,
	#instVars : [
		'startPanel',
		'endPanel'
	],
	#classVars : [
		'Experimental'
	],
	#category : #'Spec2-Adapters-PharoJs-Layout'
}

{ #category : #'experiment-toggle' }
SpPharoJsBoxAdapter class >> useExperimentalWhile: aBlock [

	Experimental := true.
	aBlock ensure: [ Experimental := false ]
]

{ #category : #factory }
SpPharoJsBoxAdapter >> add: aPresenter [
 
	self add: aPresenter constraints: SpBoxConstraints new
]

{ #category : #adding }
SpPharoJsBoxAdapter >> add: aPresenter constraints: constraints [

	super add: aPresenter constraints: constraints
]

{ #category : #private }
SpPharoJsBoxAdapter >> addConstraints: constraints toChild: childMorph [
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

{ #category : #private }
SpPharoJsBoxAdapter >> addHorizontalPadding: aNumber toMorph: aMorph [

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

{ #category : #private }
SpPharoJsBoxAdapter >> addPadding: aNumber toMorph: aMorph [
	
	aNumber = 0 ifTrue: [ ^ aMorph ].
	
	^ layout direction 
		addPadding: aNumber 
		toMorph: aMorph
		into: self
]

{ #category : #private }
SpPharoJsBoxAdapter >> addVerticalPadding: aNumber toMorph: aMorph [

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

{ #category : #private }
SpPharoJsBoxAdapter >> applyAlignmentTo: aWidget [

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

{ #category : #private }
SpPharoJsBoxAdapter >> applyAlignmentToChild: aWidget [

	layout vAlign 
		ifNotNil: [ aWidget vResizing: #rigid ].
	layout hAlign 
		ifNotNil: [ aWidget hResizing: #rigid ]

]

{ #category : #private }
SpPharoJsBoxAdapter >> basicAdd: aPresenter constraints: constraints to: aPanel [

	| childMorph msg |
	childMorph := self buildMorph: aPresenter constraints: constraints.

	self applyAlignmentToChild: childMorph.
	self verifyBoxExtentOf: aPanel withChild: childMorph.

	"	constraints isPlacedAtStart
		ifTrue: [ startPanel addMorphBack: childMorph ]
		ifFalse: [ endPanel addMorphBack: childMorph ]."
	"	widget children add: childMorph."
	msg := SpS2cAddElementToParent new.
	msg elementId: childMorph.
	msg parentId: aPanel.
	self sendUpdateMessageToClient: msg.



	^ childMorph
]

{ #category : #accessing }
SpPharoJsBoxAdapter >> children [

	^ startPanel submorphs, endPanel submorphs
]

{ #category : #accessing }
SpPharoJsBoxAdapter >> childrenWidgets [
	
	^ self children
]

{ #category : #factory }
SpPharoJsBoxAdapter >> layout: aLayout [

	layout := aLayout.
	
	widget ifNil: [
		"build of widget was differed up to here (to know what is the direction)"
		widget := aLayout direction newWidgetOn: self.
	"	widget borderWidth: aLayout borderWidth.
		aLayout hasAlignment 
			ifTrue: [ widget := self applyAlignmentTo: widget ]."
		"the spacing needs to be applied to the inner sub-panels"
		self flag: 'Ivo skipping panels'.
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

{ #category : #factory }
SpPharoJsBoxAdapter >> newHorizontal [

	"^ (self newPanelWith: self newPanelLayout)
		listDirection: #leftToRight;
		addMorphBack: ((startPanel := (self newPanelWith: SpMorphicBoxChildLayout new))
			listDirection: #leftToRight;
			yourself);
		addMorphBack: ((endPanel := (self newPanelWith: SpMorphicBoxChildLayout new))
			listDirection: #leftToRight;
			hResizing: #shrinkWrap;
			width: 0;
			yourself);
	  yourself"
	self halt.
]

{ #category : #factory }
SpPharoJsBoxAdapter >> newPanelLayout [

	"^ SpMorphicBoxLayout new
		specLayout: layout;
		yourself"

	"^ SpjRemoteElement new
	
		  oldMorphClass: SpMorphicBoxLayout name;
		  creatorMethod: thisContext method printString;
		description: 'Is probably not a remote element!!! create SpPharoJsBoxLayout instead'
		  yourself"

	
]

{ #category : #factory }
SpPharoJsBoxAdapter >> newVertical [

	^ (self newPanelWith: "self newPanelLayout" nil)
	"	listDirection: #topToBottom;"
	"	addMorphBack: ((startPanel := self newPanel)
			listDirection: #topToBottom;
			yourself);
		addMorphBack: ((endPanel := self newPanel)
			listDirection: #topToBottom;
			vResizing: #shrinkWrap;
			height: 0;
			yourself);"
		yourself
]

{ #category : #factory }
SpPharoJsBoxAdapter >> newWrapMorph [

	"^ Morph new
		  layoutPolicy: ProportionalLayout new;
		  color: Color transparent;
		  borderColor: Color transparent yourself"
		self halt.
]

{ #category : #accessing }
SpPharoJsBoxAdapter >> remove: aPresenter [

	| morph |
	morph := aPresenter adapter widget.	
	startPanel removeMorph: morph.
	endPanel removeMorph: morph.
	self verifyBoxExtent
	
]

{ #category : #accessing }
SpPharoJsBoxAdapter >> removeAll [

	startPanel removeAllMorphs.
	endPanel removeAllMorphs.
	self verifyBoxExtent
]

{ #category : #factory }
SpPharoJsBoxAdapter >> removeSubWidgets [

	startPanel removeAllMorphs.
	endPanel removeAllMorphs
]

{ #category : #accessing }
SpPharoJsBoxAdapter >> replace: aPresenter with: otherPresenter [

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

{ #category : #accessing }
SpPharoJsBoxAdapter >> replace: aPresenter with: otherPresenter withConstraints: constraints [

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

{ #category : #updating }
SpPharoJsBoxAdapter >> updateSpacing [

	{ startPanel. endPanel } 
			do: [ :each | each cellInset: layout spacing ]
]

{ #category : #private }
SpPharoJsBoxAdapter >> verifyBoxExtent [

	(startPanel hasSubmorphs not and: [ endPanel hasSubmorphs not ])
		ifTrue: [ widget extent: 0@0 ]
]

{ #category : #private }
SpPharoJsBoxAdapter >> verifyBoxExtentOf: aPanel withChild: childMorph [
	"| width height |

	width := childMorph width + (widget borderWidth * 2).
	height := childMorph height + (widget borderWidth * 2).

	layout isVertical 
		ifTrue: [ height := height + aPanel height + aPanel cellInset ]
		ifFalse: [ width := width + aPanel width + aPanel cellInset ].
		 
	aPanel extent: (aPanel width max: width)@(aPanel height max: height)"
]
