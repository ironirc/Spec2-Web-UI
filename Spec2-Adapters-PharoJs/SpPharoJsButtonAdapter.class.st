Class {
	#name : #SpPharoJsButtonAdapter,
	#superclass : #SpAbstractPharoJsAdapter,
	#instVars : [
		'subMenuWidget',
		'styleName'
	],
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> action [

	self showSubMenuIfPresent.

"	self widget ifNotNil: [:m | m takeKeyboardFocus ]."
	self model performAction.
]

{ #category : #protocol }
SpPharoJsButtonAdapter >> askBeforeChanging [

	^ self model askBeforeChanging
]

{ #category : #private }
SpPharoJsButtonAdapter >> buildLabel: text withIcon: icon [
	| iconLabel |

	icon ifNil: [ 
		^ (text localizedForPresenter: self presenter) ifNil: [ '' ] ].
	
	iconLabel := IconicListItemMorph new.
	iconLabel icon: (self presenter isEnabled
		ifTrue: [ icon ]
		ifFalse: [ icon asGrayScaleWithAlpha ]).
	text isEmptyOrNil ifFalse: [ 
		iconLabel morph: (text asMorph 
			lock;
			yourself) ].
		
	^ iconLabel
]

{ #category : #factory }
SpPharoJsButtonAdapter >> buildWidget [

	| msg id |
	"button 
		getEnabledSelector: #enabled ;
		getFontSelector: #font ;
		hResizing: #spaceFill ;
		vResizing: #spaceFill ;
		askBeforeChanging: self askBeforeChanging ;
		setBalloonText: self getHelpText ;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled ;	
		eventHandler: (MorphicEventHandler new 
			on: #keyStroke 
			send: #keyStroke:fromMorph: 
			to: self).
	button 
		bindKeyCombination: Character space 
		toAction: [ self action ]."
	self widget ifNotNil: [ ^ self ].
	id := self class nextIdString.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: id.
	msg tag: 'button'.
	msg textContent: self label.
	msg events: #( click ).
	msg styles: { 
			('background-color' -> ('#' , self color asHexString)).
			('flex-grow' -> 1) }.
	msg attributes: { ('method' -> thisContext method printString) }.
	self sendUpdateMessageToClient: msg.

	^ id
]

{ #category : #emulating }
SpPharoJsButtonAdapter >> clicked [

	| evt |
	evt := MouseButtonEvent new
		       setType: nil
		       position: widget center
		       which: MouseButtonEvent redButton
		       buttons: MouseButtonEvent redButton
		       hand: nil
		       stamp: nil.

	(widget handlesMouseDown: evt) ifTrue: [ 
		widget 
			mouseDown: evt;
			mouseUp: evt ]
]

{ #category : #updating }
SpPharoJsButtonAdapter >> colorChanged [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: widget.
	msg tag: 'button'.
	msg styles:
		{ ('background-color' -> ('#' , self color asHexString)) }.
	self sendUpdateMessageToClient: msg
]

{ #category : #'menus support' }
SpPharoJsButtonAdapter >> deleteIfPopUp: evt [
]

{ #category : #accessing }
SpPharoJsButtonAdapter >> enabled: aBoolean [

	super enabled: aBoolean.
	self widgetDo: [ :w | w label: self label ]
]

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> font [

	^ self model font
]

{ #category : #private }
SpPharoJsButtonAdapter >> getHelpText [

	^ self presenter help ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #private }
SpPharoJsButtonAdapter >> getLabelText [

	^ self presenter label ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #events }
SpPharoJsButtonAdapter >> handleClick: e [


	self model action value
]

{ #category : #accessing }
SpPharoJsButtonAdapter >> helpText [

	^ self widget helpText
]

{ #category : #accessing }
SpPharoJsButtonAdapter >> icon [

	^ widget label icon
]

{ #category : #'menus support' }
SpPharoJsButtonAdapter >> isSelected: aBooolean [
]

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> keyStroke: anEvent fromMorph: aMorph [
]

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> label [
	
	^ self 
		buildLabel: (self presenter label withAccentuatedCharacter: self presenter shortcutCharacter) 
		withIcon: self presenter icon
]

{ #category : #updating }
SpPharoJsButtonAdapter >> labelChanged [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: widget.
	msg tag: 'button'.
	msg textContent: self label.
	self sendUpdateMessageToClient: msg
]

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> menu: aMenu [

	| menuPresenter |
	menuPresenter := self model contextMenu.
	menuPresenter ifNil: [ ^ nil ].
	^ SpBindings
		  value: self model application adapterBindings
		  during: [ menuPresenter build ]
]

{ #category : #factory }
SpPharoJsButtonAdapter >> newButton [

	"Ivo Do we really need SpjButton? Isn't adapter enough?"

self halt.
	
	"	on: self
		  getState: #state
		  action: #action
		  label: #label
		  menu: #menu:"
]

{ #category : #factory }
SpPharoJsButtonAdapter >> setWidgetColor: button [

	| normalColorBlock clickedColorBlock |

	normalColorBlock := [ :aButton |
			(aButton valueOfProperty: #noFill ifAbsent: [false]) 
					ifTrue: [ SolidFillStyle color: Color transparent ]
					ifFalse: [ SolidFillStyle color: self color ] ].
	
	clickedColorBlock := [ :aButton | SolidFillStyle color: self color muchDarker ].
	button theme: ((SpUIThemeDecorator theme: button theme)
							property: #buttonNormalFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonMouseOverFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonPressedFillStyleFor: returnsValueOf: clickedColorBlock;
							yourself)
]

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> showSubMenu: aMenu [

	aMenu menuGroups ifNil: [ ^ self ].

	subMenuWidget ifNotNil: [ 
		subMenuWidget delete.
		subMenuWidget := nil ].
	subMenuWidget := (SpMorphicMenuAdapter adaptAsPopup: aMenu) widget.
	subMenuWidget
		popUpAdjacentTo: { 
				self widget bounds bottomLeft.
				self widget bounds bottomRight }
		forHand: self widget activeHand
		from: self widget.
	subMenuWidget popUpOwner: self
]

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> showSubMenuIfPresent [

	self model contextMenu ifNil: [ ^ self ].
	self showSubMenu: self model contextMenu
	
]

{ #category : #'widget API' }
SpPharoJsButtonAdapter >> state [

	^ self model state
]

{ #category : #accessing }
SpPharoJsButtonAdapter >> styleName [

	^ styleName ifNil: [ super styleName ]
]

{ #category : #accessing }
SpPharoJsButtonAdapter >> styleName: aString [ 

	styleName := aString
]

{ #category : #updating }
SpPharoJsButtonAdapter >> subcribeToModel [
	"how else to hook up to all possible change events of the presenter?"
	self subcribeToAll:  #(color label)
]

{ #category : #accessing }
SpPharoJsButtonAdapter >> unscaledInitialExtent [

	^ 15@26
]

{ #category : #updating }
SpPharoJsButtonAdapter >> updateMenu [	
	"There is no need to updateMenu here because it will be resolved at #menu:"
]
