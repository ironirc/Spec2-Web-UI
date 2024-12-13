Extension { #name : 'SpIndexTableColumn' }

{ #category : '*Spec2-Web-UI-Adapters' }
SpIndexTableColumn >> asTabulatorColumnWithIndex: i [

	| col |
	col := SpwTabulatorColumn new.
	col title: self title.
	col field: 'id'.
	col index: i.
	col width: 0.
	^col
]

{ #category : '*Spec2-Web-UI-Adapters' }
SpIndexTableColumn >> getValueFor: anObject id: id tableAdaptor: tableAdaptor [
	"id is just the index of the object in the original datasource collection of the presenter"
	"in the future other possibilities might be usefull"
	"^tableAdaptor getValueFor: anObject id: id indexColumn: self"
	^id
]
