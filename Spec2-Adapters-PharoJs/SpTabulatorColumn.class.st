Class {
	#name : #SpTabulatorColumn,
	#superclass : #PjDomController,
	#instVars : [
		'field',
		'index',
		'title',
		'width',
		'type',
		'horizontalAlignment',
		'formatter'
	],
	#category : #'Spec2-Adapters-PharoJs-Table'
}

{ #category : #accessing }
SpTabulatorColumn >> field [

	^ field
]

{ #category : #accessing }
SpTabulatorColumn >> field: anObject [

	field := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> formatter [

	^ formatter
]

{ #category : #accessing }
SpTabulatorColumn >> formatter: anObject [

	formatter := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> getFormatter [

	type = #Base64Jpg ifTrue: [
		^ [ :cell :formatterParams :onRendered | cell getValue ] ].
	^ formatter
]

{ #category : #accessing }
SpTabulatorColumn >> horizontalAlignment [

	^ horizontalAlignment
]

{ #category : #accessing }
SpTabulatorColumn >> horizontalAlignment: anObject [

	horizontalAlignment := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> index [

	^ index
]

{ #category : #accessing }
SpTabulatorColumn >> index: anObject [

	index := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> title [

	^ title
]

{ #category : #accessing }
SpTabulatorColumn >> title: anObject [

	title := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> type [

	^ type
]

{ #category : #accessing }
SpTabulatorColumn >> type: anObject [

	type := anObject
]

{ #category : #accessing }
SpTabulatorColumn >> unpackBase64Jpg: anObject [

	^ global Image new
		  src: 'data:image/jpeg;base64,' , anObject b64Array;
		  yourself
]

{ #category : #accessing }
SpTabulatorColumn >> unpackTableColumnData: anObject [

	type = #Base64Jpg ifTrue: [ ^self unpackBase64Jpg: anObject ].
	^ anObject
]

{ #category : #accessing }
SpTabulatorColumn >> width [

	^ width
]

{ #category : #accessing }
SpTabulatorColumn >> width: anObject [

	width := anObject
]
