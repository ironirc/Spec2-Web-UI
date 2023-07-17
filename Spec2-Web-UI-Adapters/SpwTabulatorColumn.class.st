Class {
	#name : #SpwTabulatorColumn,
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
	#category : #'Spec2-Web-UI-Adapters-Table'
}

{ #category : #accessing }
SpwTabulatorColumn >> field [

	^ field
]

{ #category : #accessing }
SpwTabulatorColumn >> field: anObject [

	field := anObject
]

{ #category : #accessing }
SpwTabulatorColumn >> formatter [

	^ formatter
]

{ #category : #accessing }
SpwTabulatorColumn >> formatter: anObject [

	formatter := anObject
]

{ #category : #accessing }
SpwTabulatorColumn >> getFormatter [

	type = #Base64Jpg ifTrue: [
		^ [ :cell :formatterParams :onRendered | cell getValue ] ].
	^ formatter
]

{ #category : #accessing }
SpwTabulatorColumn >> horizontalAlignment [

	^ horizontalAlignment
]

{ #category : #accessing }
SpwTabulatorColumn >> horizontalAlignment: anObject [

	horizontalAlignment := anObject
]

{ #category : #accessing }
SpwTabulatorColumn >> index [

	^ index
]

{ #category : #accessing }
SpwTabulatorColumn >> index: anObject [

	index := anObject
]

{ #category : #accessing }
SpwTabulatorColumn >> title [

	^ title
]

{ #category : #accessing }
SpwTabulatorColumn >> title: anObject [

	title := anObject
]

{ #category : #accessing }
SpwTabulatorColumn >> type [

	^ type
]

{ #category : #accessing }
SpwTabulatorColumn >> type: anObject [

	type := anObject
]

{ #category : #accessing }
SpwTabulatorColumn >> unpackBase64Jpg: anSpwImage [

	^ global Image new
		  src: 'data:image/png;base64,' , anSpwImage getB64Array;
		  yourself
]

{ #category : #accessing }
SpwTabulatorColumn >> unpackTableColumnData: anObject [

	type = #Base64Jpg ifTrue: [ ^self unpackBase64Jpg: anObject ].
	^ anObject
]

{ #category : #accessing }
SpwTabulatorColumn >> width [

	^ width
]

{ #category : #accessing }
SpwTabulatorColumn >> width: anObject [

	width := anObject
]
