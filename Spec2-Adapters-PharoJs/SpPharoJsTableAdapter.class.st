Class {
	#name : #SpPharoJsTableAdapter,
	#superclass : #SpAbstractPharoJsListAdapter,
	#category : #'Spec2-Adapters-PharoJs-Table'
}

{ #category : #accessing }
SpPharoJsTableAdapter class >> intercellSpacing [

	^ 2@0
]

{ #category : #initialization }
SpPharoJsTableAdapter >> addKeyBindingsTo: aWidget [

	super addKeyBindingsTo: aWidget.
	self addContextMenuKeyBindings: aWidget
]

{ #category : #factory }
SpPharoJsTableAdapter >> addModelTo: tableMorph [

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
SpPharoJsTableAdapter >> alternateRowsColor [
	self widgetDo: [ :w | w alternateRowsColor: true ]
]

{ #category : #factory }
SpPharoJsTableAdapter >> buildWidget [

	"widget := SpFTTableMorph new
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		intercellSpacing: self class intercellSpacing;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		yourself.
	self addModelTo: widget.
	^ widget"

	| id msg |
	id := self class nextIdString.
	msg := SpS2cCreateTabulatorTable new.
	msg styles: { 
			"('height' -> '500px')".
			"('flex' -> 1)" }.
	msg elementId: id.
"	msg data: model items.
	msg columns: self tabulatorColumns."
	self sendMessageToClient: msg.
	^ id
]

{ #category : #emulating }
SpPharoJsTableAdapter >> clickOnColumnHeaderAt: anIndex [
	self widgetDo: [ :tableWidget | tableWidget clickOnColumnHeaderAt: anIndex ]
]

{ #category : #testing }
SpPharoJsTableAdapter >> columns [
	^ widget columns
]

{ #category : #factory }
SpPharoJsTableAdapter >> defaultColumn [

	^ SpStringTableColumn new evaluated: #yourself
]

{ #category : #factory }
SpPharoJsTableAdapter >> ensureAtLeastOneColumnIn: tableMorph [
	self model columns ifNotEmpty: [ ^ self ].
	tableMorph addColumn: (self newColumnFrom: self defaultColumn)
]

{ #category : #private }
SpPharoJsTableAdapter >> ifSorted: sortedBlock ifNotSorted: notSortedBlock [ 
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
SpPharoJsTableAdapter >> isNonEditableRow: aRow column: aColumn [

	^ (self widget dataSource
		cellColumn: (self widget columns at: aColumn)
		row: aRow) submorphs allSatisfy: [ :e | e asReadOnlyMorph == e ]
]

{ #category : #testing }
SpPharoJsTableAdapter >> isResizable [
	^ self model isResizable
]

{ #category : #testing }
SpPharoJsTableAdapter >> isShowColumnHeaders [

	^ widget isShowColumnHeaders 	
]

{ #category : #testing }
SpPharoJsTableAdapter >> isShowingColumnHeaders [
	^ self model isShowingColumnHeaders
]

{ #category : #'private - factory' }
SpPharoJsTableAdapter >> newColumnFrom: aTableColumn [

	^ (SpMorphicTableColumn on: aTableColumn)
		width: aTableColumn width;
		yourself
]

{ #category : #'private - factory' }
SpPharoJsTableAdapter >> newDataSource [ 

	^ SpMorphicTableDataSource new
		model: self model;
		yourself

]

{ #category : #factory }
SpPharoJsTableAdapter >> refreshColumnsInWidget [

	widget columns: (self model columns collect: [ :each | self newColumnFrom: each ]).
	self ensureAtLeastOneColumnIn: widget.
]

{ #category : #refreshing }
SpPharoJsTableAdapter >> refreshList [

	^ self widget refresh
]

{ #category : #refreshing }
SpPharoJsTableAdapter >> refreshModel [

	widget dataSource resetElements.
	self
		ifSorted: [ :sortingStrategyState | sortingStrategyState executeSortingOn: widget dataSource ]
		ifNotSorted: [ self refreshList ]
]

{ #category : #factory }
SpPharoJsTableAdapter >> refreshShowColumnHeaders [
	
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
SpPharoJsTableAdapter >> refreshWidgetSelection [
	| rowIndexes |
	rowIndexes := self presenter selection selectedIndexes.
	rowIndexes = self widget selectedIndexes
		ifTrue: [ ^ self ].
	rowIndexes isEmpty
		ifTrue: [ self widget basicSelectIndexes: #() ]
		ifFalse: [ self widget basicSelectIndexes: rowIndexes ].
	^ self refreshList
]

{ #category : #selection }
SpPharoJsTableAdapter >> selectIndex: anInteger [ 

	(anInteger = 0 and: [ widget selectedIndexes isEmpty ]) ifTrue: [ ^ self ].	
	(widget selectedIndexes includes: anInteger) ifTrue: [^self].
	widget selectIndex: anInteger
]

{ #category : #testing }
SpPharoJsTableAdapter >> selectedIndexes [
	
	^ widget selectedIndexes 
]

{ #category : #factory }
SpPharoJsTableAdapter >> selectionChanged: ann [
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
SpPharoJsTableAdapter >> sendRightClickEvent [
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
SpPharoJsTableAdapter >> strongSelectionChanged: aFTStrongSelectionChanged [

	self presenter activatesOnDoubleClick ifFalse: [ ^ self ].	
	self presenter doubleClickAtIndex: aFTStrongSelectionChanged selectedIndex
]

{ #category : #factory }
SpPharoJsTableAdapter >> tabulatorColumns [

	^ self columns collect: [ :specCol | 
		  { 
			  ('title' -> specCol title).
			  ('field' -> specCol evaluation).
			  ('editor' -> 'input') } ]
]

{ #category : #'drag and drop' }
SpPharoJsTableAdapter >> transferFrom: aTransferMorph event: anEvent [
	| rowAndColumn |

	rowAndColumn := self widget container rowAndColumnIndexContainingPoint: anEvent position.
	^ SpDragAndDropTransferToTable new
		passenger: aTransferMorph passenger;
		row: (rowAndColumn first ifNil: [ 0 ]);
		column: (rowAndColumn second ifNil: [ 0 ]);
		yourself
]

{ #category : #updating }
SpPharoJsTableAdapter >> updateMenu [
	
	"there is no need to updateMenu here because it will be resolved at the dataSource"
]
