Extension { #name : #SpStringTableColumn }

{ #category : #'*Spec2-Adapters-PharoJs' }
SpStringTableColumn >> asTabulatorColumnWithIndex: i [

	| col |
	col := SpTabulatorColumn new.
	col title: self title.
	col field: 'col' , i printString.
	col type: #String.
	col index: i.
	self displayAlignment ifNotNil: [ :da |
		col horizontalAlignment: (da value: nil) asTabulatorAlignment ].
	^ col
]

{ #category : #'*Spec2-Adapters-PharoJs' }
SpStringTableColumn >> getValueFor: anObject id: id tableAdaptor: tableAdaptor [
	"^tableAdaptor getValueFor: anObject id: id stringColumn: self"
	^self evaluation value: anObject
]
