Extension { #name : #SpStringTableColumn }

{ #category : #'*Spec2-Web-UI-Adapters' }
SpStringTableColumn >> asTabulatorColumnWithIndex: i [

	| col |
	col := SpwTabulatorColumn new.
	col title: self title.
	col field: 'col' , i printString.
	col type: #String.
	col index: i.
	self displayAlignment ifNotNil: [ :da |
		col horizontalAlignment: (da value: nil) asTabulatorAlignment ].
	^ col
]

{ #category : #'*Spec2-Web-UI-Adapters' }
SpStringTableColumn >> getValueFor: anObject id: id tableAdaptor: tableAdaptor [
	"^tableAdaptor getValueFor: anObject id: id stringColumn: self"
	^self evaluation value: anObject
]
