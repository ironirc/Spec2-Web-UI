Class {
	#name : 'SpwAbstractList_A',
	#superclass : 'SpwAbstractAdapter',
	#category : 'Spec2-Web-UI-Adapters-List',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'List'
}

{ #category : 'testing' }
SpwAbstractList_A class >> isAbstract [
	^ self = SpwAbstractList_A
]

{ #category : 'drag and drop' }
SpwAbstractList_A >> acceptDroppingMorph: aTransferMorph event: anEvent [ 
	
	self presenter acceptDrop cull: (self 
		transferFrom: aTransferMorph 
		event: anEvent)
]

{ #category : 'initialization' }
SpwAbstractList_A >> addActivationKeyBindings: aWidget [

	self 
		bindKeyCombination: Character cr asKeyCombination
		toAction: [ self triggerActivationAction ]
]

{ #category : 'initialization' }
SpwAbstractList_A >> addKeyBindingsTo: aWidget [

	super addKeyBindingsTo: aWidget.
	self addContextMenuKeyBindings: aWidget.
	self addActivationKeyBindings: aWidget
]

{ #category : 'scrolling' }
SpwAbstractList_A >> configureScrolling [
	self presenter verticalAlignment
		whenChangedDo: [ widget
				scrollToIndex: self presenter verticalAlignment desiredVisibleRow ].
			
	self presenter
		whenDisplayDo: [ widget
				scrollToIndex: self presenter verticalAlignment desiredVisibleRow.
			self scrollingChanged ].
		
	widget
		onAnnouncement: FTScrollingChanged
		send: #scrollingChanged
		to: self.
]

{ #category : 'widget API' }
SpwAbstractList_A >> elementAt: index [

	^ self widget dataSource elementAt: index
]

{ #category : 'widget API' }
SpwAbstractList_A >> itemFilter [
	^ self model itemFilter
]

{ #category : 'scrolling' }
SpwAbstractList_A >> scrollingChanged [
	widget container updateAllRows.
	self presenter verticalAlignment
		firstVisibleRowIndex: widget firstVisibleRowIndex;
		lastVisibleRowIndex: widget lastVisibleRowIndex
]

{ #category : 'emulating' }
SpwAbstractList_A >> sendClickEventToRow: aNumber [
	| evt rowWidget |

	rowWidget := widget container submorphs at: aNumber.
	evt := MouseButtonEvent new 
		setType: nil 
		position: rowWidget bounds center 
		which: MouseButtonEvent redButton 
		buttons: MouseButtonEvent redButton 
		hand: self currentHand 
		stamp: nil.
	
	(widget handlesMouseDown: evt) ifTrue: [
		widget handleMouseDown: evt.
		widget handleMouseUp: evt ]
]

{ #category : 'emulating' }
SpwAbstractList_A >> sendClickWithShiftEventToRow: aNumber [
	| evt rowWidget |

	rowWidget := widget container submorphs at: aNumber.
	evt := MouseButtonEvent new 
		setType: nil 
		position: rowWidget bounds center 
		which: MouseButtonEvent redButton 
		buttons: (MouseButtonEvent redButton | 8 "shift = 8 mask")
		hand: self currentHand 
		stamp: nil.
	
	(widget handlesMouseDown: evt) ifTrue: [
		widget handleMouseDown: evt.
		widget handleMouseUp: evt ]
]

{ #category : 'private' }
SpwAbstractList_A >> showContextMenu [

	self widgetDo: [ :w |
		w showMenuForIndex: { self presenter selection selectedIndex. 1 } ]
]

{ #category : 'drag and drop' }
SpwAbstractList_A >> transferFrom: aTransferMorph event: anEvent [
	| rowAndColumn |

	rowAndColumn := self widget container rowAndColumnIndexContainingPoint: anEvent position.
	^ SpDragAndDropTransferToList new
		passenger: aTransferMorph passenger;
		index: (rowAndColumn first ifNil: [ 0 ]);
		yourself
]

{ #category : 'private' }
SpwAbstractList_A >> triggerActivationAction [

	self presenter doActivateAtIndex: self presenter selection selectedIndex
]

{ #category : 'factory' }
SpwAbstractList_A >> updateItemFilterBlockWith: block [

	^ block
		ifNotNil: [ 
			widget
				enableFilter: (SpFTSpecFilter block: block);
				explicitFunction ]
		ifNil: [ 
			self updateSearch ]
]

{ #category : 'factory' }
SpwAbstractList_A >> updateSearch [

	self presenter isSearchEnabled
		ifTrue: [ widget enableSearch ]
		ifFalse: [ widget disableFunction ]
]

{ #category : 'drag and drop' }
SpwAbstractList_A >> wantsDroppedMorph: aTransferMorph event: anEvent [ 
	
	^ self presenter wantsDrop cull: (self 
		transferFrom: aTransferMorph 
		event: anEvent)
]
