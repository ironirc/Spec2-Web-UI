Class {
	#name : #'SpwTable_A',
	#superclass : #'SpwAbstractList_A',
	#category : #'Spec2-Web-UI-Adapters-Table'
}

{ #category : #accessing }
SpwTable_A class >> intercellSpacing [

	^ 2@0
]

{ #category : #initialization }
SpwTable_A >> addKeyBindingsTo: aWidget [

	super addKeyBindingsTo: aWidget.
	self addContextMenuKeyBindings: aWidget
]

{ #category : #factory }
SpwTable_A >> addModelTo: tableMorph [

	self model columns do: [ :each |
		tableMorph addColumn: (self newColumnFrom: each) ].
	self ensureAtLeastOneColumnIn: tableMorph.

	self isResizable 
		ifTrue: [ tableMorph beResizable ] 
		ifFalse: [ tableMorph beNotResizable ].
	
	tableMorph setMultipleSelection: self model isMultipleSelection.

	self refreshShowColumnHeaders.
	self refreshWidgetSelection.
	
	self presenter whenShowColumnHeadersChangedDo: [ :showColumns |
		self refreshShowColumnHeaders ].

	self presenter whenModelChangedDo: [ self refreshModel ].
	self presenter whenColumnsChangedDo: [ self refreshColumnsInWidget ].
	
	tableMorph setBalloonText: self help.

	self configureScrolling.

	tableMorph
		onAnnouncement: FTSelectionChanged
			send: #selectionChanged:
			to: self;
		onAnnouncement: FTStrongSelectionChanged
			send: #strongSelectionChanged:
			to: self.

	tableMorph dataSource: self newDataSource.
	
	self presenter whenItemFilterBlockChangedDo: [ :block | 
		self updateItemFilterBlockWith: block ].
	self presenter whenSearchEnabledChangedDo: [ 
		self updateSearch ].
	self updateItemFilterBlockWith: self itemFilter
]

{ #category : #configuring }
SpwTable_A >> alternateRowsColor [
	self widgetDo: [ :w | w alternateRowsColor: true ]
]

{ #category : #factory }
SpwTable_A >> buildWidget [

	"widget := SpFTTableMorph new
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		intercellSpacing: self class intercellSpacing;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		yourself.
	self addModelTo: widget.
	^ widget"

	| rw msg |
	rw := self newRemoteWidget.
	msg := SpS2cCreateTabulatorTable new.
	msg styles: { 
			"('height' -> '500px')".
			"('flex' -> 1)" }.
	msg elementId: rw id.
"	msg data: model items."
	msg columns: self tabulatorColumns.
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
	^ rw
]

{ #category : #emulating }
SpwTable_A >> clickOnColumnHeaderAt: anIndex [
	self widgetDo: [ :tableWidget | tableWidget clickOnColumnHeaderAt: anIndex ]
]

{ #category : #testing }
SpwTable_A >> columns [
	^ widget columns
]

{ #category : #private }
SpwTable_A >> convertObjectToArrayForTabulator: anObject id: id [

	^ model columns collect: [ :col | 
		  col getValueFor: anObject id: id tableAdaptor: self ]
]

{ #category : #factory }
SpwTable_A >> defaultColumn [

	^ SpStringTableColumn new evaluated: #yourself
]

{ #category : #factory }
SpwTable_A >> ensureAtLeastOneColumnIn: tableMorph [
	self model columns ifNotEmpty: [ ^ self ].
	tableMorph addColumn: (self newColumnFrom: self defaultColumn)
]

{ #category : #private }
SpwTable_A >> ifSorted: sortedBlock ifNotSorted: notSortedBlock [ 
	widget columns 
		do: [ :column | | state | 
			column isSorted
				ifTrue: [ 
					state := column sortingStrategy state.
					state isSorted
						ifTrue: [ ^ sortedBlock cull: state ] ] ].
	^ notSortedBlock value
]

{ #category : #testing }
SpwTable_A >> isNonEditableRow: aRow column: aColumn [

	^ (self widget dataSource
		cellColumn: (self widget columns at: aColumn)
		row: aRow) submorphs allSatisfy: [ :e | e asReadOnlyMorph == e ]
]

{ #category : #testing }
SpwTable_A >> isResizable [
	^ self model isResizable
]

{ #category : #testing }
SpwTable_A >> isShowColumnHeaders [

	^ widget isShowColumnHeaders 	
]

{ #category : #testing }
SpwTable_A >> isShowingColumnHeaders [
	^ self model isShowingColumnHeaders
]

{ #category : #'private - factory' }
SpwTable_A >> newColumnFrom: aTableColumn [

	^ (SpMorphicTableColumn on: aTableColumn)
		width: aTableColumn width;
		yourself
]

{ #category : #'private - factory' }
SpwTable_A >> newDataSource [ 

	^ SpMorphicTableDataSource new
		model: self model;
		yourself

]

{ #category : #factory }
SpwTable_A >> refreshColumnsInWidget [

	widget columns: (self model columns collect: [ :each | self newColumnFrom: each ]).
	self ensureAtLeastOneColumnIn: widget.
]

{ #category : #refreshing }
SpwTable_A >> refreshList [

	^ self widget refresh
]

{ #category : #refreshing }
SpwTable_A >> refreshModel [

	widget dataSource resetElements.
	self
		ifSorted: [ :sortingStrategyState | sortingStrategyState executeSortingOn: widget dataSource ]
		ifNotSorted: [ self refreshList ]
]

{ #category : #factory }
SpwTable_A >> refreshShowColumnHeaders [
	
	self presenter isShowingColumnHeaders 
		ifTrue: [ 
			self widget
				showColumnHeaders;
				refresh ]
		ifFalse: [ 
			self widget
				hideColumnHeaders;
				refresh ]
]

{ #category : #refreshing }
SpwTable_A >> refreshWidgetSelection [

	| rowIndexes msg |
	rowIndexes := self presenter selection selectedIndexes.
	rowIndexes = self selectedIndexes ifTrue: [ ^ self ].
	msg := SpS2cUpdateTabulatorTable new.
	msg elementId: widget id.
	msg selections: rowIndexes.
	self sendMessageToClient: msg
]

{ #category : #selection }
SpwTable_A >> selectIndex: anInteger [ 

"	(anInteger = 0 and: [ widget selectedIndexes isEmpty ]) ifTrue: [ ^ self ].	
	(widget selectedIndexes includes: anInteger) ifTrue: [^self].
	widget selectIndex: anInteger"

]

{ #category : #testing }
SpwTable_A >> selectedIndexes [

	| msg envelope |
	msg := SpS2cQuerySomeStuff new.
	msg elementId: widget id.
	msg selectors: #( selectedIndexes ).
	envelope := self sendMessageToClient: msg.
	^ envelope msg results first value
]

{ #category : #factory }
SpwTable_A >> selectionChanged: ann [
	| diff selection |

	selection := self presenter selection.
	selection selectIndexes: (selection isMultipleSelection
		ifTrue: [ 
			 (ann newSelectedIndexes reject: [ :e | e = 0 ]) ]
		ifFalse: [ 
			{ ann newSelectedIndexes
				ifNotEmpty: [ :indexes | indexes first ]
				ifEmpty: [ 0 ] } ]).

	diff := ann newSelectedIndexes difference: ann oldSelectedIndexes.
	(diff notEmpty and: [ self presenter activatesOnSingleClick ])
		ifTrue: [ self presenter doActivateAtIndex: diff last ].
		
	ann newSelectedIndexes ifEmpty: [ selection unselectAll ]
]

{ #category : #emulating }
SpwTable_A >> sendRightClickEvent [
	| evt |

	evt := MouseButtonEvent new 
		setType: nil 
		position: widget center 
		which: MouseButtonEvent yellowButton 
		buttons: MouseButtonEvent yellowButton 
		hand: nil 
		stamp: nil.
	
	self widget click: evt
]

{ #category : #factory }
SpwTable_A >> strongSelectionChanged: aFTStrongSelectionChanged [

	self presenter activatesOnDoubleClick ifFalse: [ ^ self ].	
	self presenter doubleClickAtIndex: aFTStrongSelectionChanged selectedIndex
]

{ #category : #factory }
SpwTable_A >> tabulatorColumns [

	"Sp2F  (stands for spec to front) experimenting with coding fragments to designate intentions "

	^ model columns withIndexCollect: [ :specCol :i | 
		specCol asTabulatorColumnWithIndex: i. 
		

		  "  ('title' -> specCol title).
			  ('field' -> specCol evaluation asString).
			  ('editor' -> 'input').
			  ('formatter' -> 'html') } asJsObject" ]
]

{ #category : #'drag and drop' }
SpwTable_A >> transferFrom: aTransferMorph event: anEvent [
	| rowAndColumn |

	rowAndColumn := self widget container rowAndColumnIndexContainingPoint: anEvent position.
	^ SpDragAndDropTransferToTable new
		passenger: aTransferMorph passenger;
		row: (rowAndColumn first ifNil: [ 0 ]);
		column: (rowAndColumn second ifNil: [ 0 ]);
		yourself
]

{ #category : #updating }
SpwTable_A >> updateMenu [
	
	"there is no need to updateMenu here because it will be resolved at the dataSource"
]
