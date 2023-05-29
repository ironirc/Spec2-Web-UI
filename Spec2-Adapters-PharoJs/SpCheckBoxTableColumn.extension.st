Extension { #name : #SpCheckBoxTableColumn }

{ #category : #'*Spec2-Adapters-PharoJs' }
SpCheckBoxTableColumn >> asTabulatorColumnWithIndex: i [

	| col |
	col := SpTabulatorColumn new.
	col title: self title.
	col field: 'col' , i printString.
	col index: i.
	col type: #checkBox.
	self displayAlignment ifNotNil: [ :da |
		col horizontalAlignment: (da value: nil) asTabulatorAlignment ].
	^ col
]

{ #category : #'*Spec2-Adapters-PharoJs' }
SpCheckBoxTableColumn >> getValueFor: anObject id: id tableAdaptor: tableAdaptor [
	"^tableAdaptor getValueFor: anObject id: id stringColumn: self"
	^self evaluation value: anObject
]
