Class {
	#name : #SpPharoJsStyle,
	#superclass : #Object,
	#instVars : [
		'styles',
		'mergedProperties'
	],
	#category : #'Spec2-Adapters-PharoJs-Stylesheet'
}

{ #category : #'instance creation' }
SpPharoJsStyle class >> fromStylesheet: aStyle adapter: anAdapter [
	"I collect all styles that apply to an adapter.
	 I traverse all styles in a very precise order: from more generic to more specific, this way 
	 the order of the collected elements will be in reverse order of execution."

	^ self 
		fromStylesheet: aStyle 
		baseStyleName: anAdapter styleName 
		otherStyles: anAdapter presenterStyles
]

{ #category : #'instance creation' }
SpPharoJsStyle class >> fromStylesheet: aStyle baseStyleName: aName otherStyles: otherStyleNames [
	"I collect all styles that apply to an adapter.
	 I traverse all styles in a very precise order: from more generic to more specific, this way 
	 the order of the collected elements will be in reverse order of execution."
	| allStyleClasses styles |
		
	allStyleClasses := aStyle flattenClasses.
	styles := OrderedCollection new.
	(({ 'application'. aName }, 
		otherStyleNames, 
		(otherStyleNames collect: [ :each | aName, '.', each ])) 
		do: [ :each |
			"a hack to not do a double dispatch on string :(" 
			each isString 
				ifTrue: [ 
					allStyleClasses 
						select: [ :eachStyle | eachStyle fullName = each ]
						thenDo: [ :aStyleClass | styles add: aStyleClass ] ] 
				ifFalse: [ 
					styles add: each ] ]).
	"WARNING. Order is important"
	^ self newStyles: styles asArray
]

{ #category : #'instance creation' }
SpPharoJsStyle class >> newStyles: anArray [

	^ self new 
		styles: anArray;
		yourself
]

{ #category : #accessing }
SpPharoJsStyle >> applyTo: aMorph [ 
"Ivo lets skip for now"
	"aMorph setProperty: #style toValue: self.
	self mergedProperties 
		do: [ :each | each applyTo: aMorph ]"
]

{ #category : #'accessing - container' }
SpPharoJsStyle >> borderWidth [

	^ self lookupProperty: SpContainerStyle valueOf: #borderWidth
]

{ #category : #private }
SpPharoJsStyle >> calculateMergedProperties [
	| properties groups |
	
	properties := OrderedCollection new.
	groups := (self styles 
		flatCollect: [ :each | each properties ])
		groupedBy: [ :each | each class ].
		
	groups valuesDo: [ :eachCollection |
		properties add: (eachCollection allButFirst 
			inject: eachCollection first
			into: [ :all :each | all, each ]) ].
	
	^ properties
]

{ #category : #'accessing - geometry' }
SpPharoJsStyle >> extent [

	^ self lookupProperty: SpGeometryStyle valueOf: #extent
]

{ #category : #'accessing - font' }
SpPharoJsStyle >> font [

	^ self lookupProperty: SpFontStyle valueOf: #definedFont
]

{ #category : #'accessing - geometry' }
SpPharoJsStyle >> height [

	^ self lookupProperty: SpGeometryStyle valueOf: #height
]

{ #category : #accessing }
SpPharoJsStyle >> lookupProperty: aPropertyClass valueOf: aSymbol [
	"I perform the lookup of a property, for which I need a class and a property name.
	 I will traverse all collected properties from last to first, to ensure most detailed 
	 property is answered"

	(self propertiesLike: aPropertyClass)
		reverseDo: [ :each | 
			(each perform: aSymbol) 
				ifNotNil: [ :value | ^ value ] ].
	^ nil
]

{ #category : #'accessing - geometry' }
SpPharoJsStyle >> maxHeight [

	^ self lookupProperty: SpGeometryStyle valueOf: #maxHeight
]

{ #category : #'accessing - geometry' }
SpPharoJsStyle >> maxWidth [

	^ self lookupProperty: SpGeometryStyle valueOf: #maxWidth
]

{ #category : #accessing }
SpPharoJsStyle >> mergedLookupProperty: aPropertyClass valueOf: aSymbol [
	"I perform the lookup of a property, for which I need a class and a property name.
	 I will traverse all collected properties from last to first, to ensure most detailed 
	 property is answered"

	^ (self mergedPropertiesLike: aPropertyClass) first
		
]

{ #category : #accessing }
SpPharoJsStyle >> mergedProperties [

	^ mergedProperties ifNil: [ mergedProperties := self calculateMergedProperties ]
]

{ #category : #private }
SpPharoJsStyle >> mergedPropertiesLike: aClass [

	^ self mergedProperties select: [ :eachProperty | eachProperty class = aClass ]
		
]

{ #category : #'accessing - geometry' }
SpPharoJsStyle >> minHeight [

	^ self lookupProperty: SpGeometryStyle valueOf: #minHeight
]

{ #category : #'accessing - geometry' }
SpPharoJsStyle >> minWidth [

	^ self lookupProperty: SpGeometryStyle valueOf: #minWidth
]

{ #category : #'accessing - container' }
SpPharoJsStyle >> padding [ 

	^ self lookupProperty: SpContainerStyle valueOf: #padding
]

{ #category : #private }
SpPharoJsStyle >> propertiesLike: aClass [

	^ (self styles 
		inject: OrderedCollection new
		into: [ :all :eachStyle | 
			eachStyle properties 
				select: [ :eachProperty | eachProperty class = aClass ]
				thenDo: [ :eachProperty | all add: eachProperty ].
			all ])
		flattened
]

{ #category : #accessing }
SpPharoJsStyle >> styles [
	^ styles
]

{ #category : #accessing }
SpPharoJsStyle >> styles: anObject [
	styles := anObject
]

{ #category : #'accessing - geometry' }
SpPharoJsStyle >> width [

	^ self lookupProperty: SpGeometryStyle valueOf: #width
]
