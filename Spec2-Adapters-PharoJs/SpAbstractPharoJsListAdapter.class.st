Class {
	#name : #SpAbstractPharoJsListAdapter,
	#superclass : #SpAbstractPharoJsAdapter,
	#category : #'Spec2-Adapters-PharoJs-List'
}

{ #category : #testing }
SpAbstractPharoJsListAdapter class >> isAbstract [
	^ self = SpAbstractMorphicListAdapter
]

{ #category : #'drag and drop' }
SpAbstractPharoJsListAdapter >> acceptDroppingMorph: aTransferMorph event: anEvent [ 
	
	self presenter acceptDrop cull: (self 
		transferFrom: aTransferMorph 
		event: anEvent)
]

{ #category : #initialization }
SpAbstractPharoJsListAdapter >> addActivationKeyBindings: aWidget [

	self 
		bindKeyCombination: Character cr asKeyCombination
		toAction: [ self triggerActivationAction ]
]

{ #category : #initialization }
SpAbstractPharoJsListAdapter >> addKeyBindingsTo: aWidget [

	super addKeyBindingsTo: aWidget.
	self addContextMenuKeyBindings: aWidget.
	self addActivationKeyBindings: aWidget
]

{ #category : #scrolling }
SpAbstractPharoJsListAdapter >> configureScrolling [
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

{ #category : #'widget API' }
SpAbstractPharoJsListAdapter >> elementAt: index [

	^ self widget dataSource elementAt: index
]

{ #category : #'widget API' }
SpAbstractPharoJsListAdapter >> itemFilter [
	^ self model itemFilter
]

{ #category : #scrolling }
SpAbstractPharoJsListAdapter >> scrollingChanged [
	widget container updateAllRows.
	self presenter verticalAlignment
		firstVisibleRowIndex: widget firstVisibleRowIndex;
		lastVisibleRowIndex: widget lastVisibleRowIndex
]

{ #category : #emulating }
SpAbstractPharoJsListAdapter >> sendClickEventToRow: aNumber [
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

{ #category : #emulating }
SpAbstractPharoJsListAdapter >> sendClickWithShiftEventToRow: aNumber [
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

{ #category : #private }
SpAbstractPharoJsListAdapter >> showContextMenu [

	self widgetDo: [ :w |
		w showMenuForIndex: { self presenter selection selectedIndex. 1 } ]
]

{ #category : #'drag and drop' }
SpAbstractPharoJsListAdapter >> transferFrom: aTransferMorph event: anEvent [
	| rowAndColumn |

	rowAndColumn := self widget container rowAndColumnIndexContainingPoint: anEvent position.
	^ SpDragAndDropTransferToList new
		passenger: aTransferMorph passenger;
		index: (rowAndColumn first ifNil: [ 0 ]);
		yourself
]

{ #category : #private }
SpAbstractPharoJsListAdapter >> triggerActivationAction [

	self presenter doActivateAtIndex: self presenter selection selectedIndex
]

{ #category : #factory }
SpAbstractPharoJsListAdapter >> updateItemFilterBlockWith: block [

	^ block
		ifNotNil: [ 
			widget
				enableFilter: (SpFTSpecFilter block: block);
				explicitFunction ]
		ifNil: [ 
			self updateSearch ]
]

{ #category : #factory }
SpAbstractPharoJsListAdapter >> updateSearch [

	self presenter isSearchEnabled
		ifTrue: [ widget enableSearch ]
		ifFalse: [ widget disableFunction ]
]

{ #category : #'drag and drop' }
SpAbstractPharoJsListAdapter >> wantsDroppedMorph: aTransferMorph event: anEvent [ 
	
	^ self presenter wantsDrop cull: (self 
		transferFrom: aTransferMorph 
		event: anEvent)
]
