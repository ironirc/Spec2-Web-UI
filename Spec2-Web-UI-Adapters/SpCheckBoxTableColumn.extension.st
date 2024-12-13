Extension { #name : 'SpCheckBoxTableColumn' }

{ #category : '*Spec2-Web-UI-Adapters' }
SpCheckBoxTableColumn >> asTabulatorColumnWithIndex: i [

	| col |
	col := SpwTabulatorColumn new.
	col title: self title.
	col field: 'col' , i printString.
	col index: i.
	col type: #Boolean.
	col formatter: #tickCross.
	self displayAlignment ifNotNil: [ :da |
		col horizontalAlignment: (da value: nil) asTabulatorAlignment ].
	^ col
]

{ #category : '*Spec2-Web-UI-Adapters' }
SpCheckBoxTableColumn >> getValueFor: anObject id: id tableAdaptor: tableAdaptor [
	"^tableAdaptor getValueFor: anObject id: id stringColumn: self"
	^self evaluation value: anObject
]
