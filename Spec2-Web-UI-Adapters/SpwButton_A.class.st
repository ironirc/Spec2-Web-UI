Class {
	#name : #'SpwButton_A',
	#superclass : #SpwAbstractAdapter,
	#instVars : [
		'subMenuWidget',
		'styleName'
	],
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #constants }
SpwButton_A class >> remoteWidgetClass [ 

	^SpwButton_RW
]

{ #category : #'widget API' }
SpwButton_A >> action [

	self showSubMenuIfPresent.

"	self widget ifNotNil: [:m | m takeKeyboardFocus ]."
	self model performAction.
]

{ #category : #protocol }
SpwButton_A >> askBeforeChanging [

	^ self model askBeforeChanging
]

{ #category : #private }
SpwButton_A >> buildLabel: text withIcon: icon [
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
SpwButton_A >> buildWidget [

	| rw |
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
	rw := self newRemoteWidget.
	rw sendCreateMessage.
	^ rw
]

{ #category : #emulating }
SpwButton_A >> clicked [

	self sendClickEvent 
]

{ #category : #updating }
SpwButton_A >> colorChanged [

	| msg |
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: widget.
	msg tag: 'button'.
	msg styles:
		{ ('background-color' -> ('#' , self color asHexString)) }.
	self sendMessageToClient: msg
]

{ #category : #'menus support' }
SpwButton_A >> deleteIfPopUp: evt [
]

{ #category : #accessing }
SpwButton_A >> enabled: aBoolean [

	super enabled: aBoolean.
	self widgetDo: [ :w | w label: self label ]
]

{ #category : #'widget API' }
SpwButton_A >> font [

	^ self model font
]

{ #category : #private }
SpwButton_A >> getHelpText [

	^ self presenter help ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #private }
SpwButton_A >> getLabelText [

	^ self presenter label ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #events }
SpwButton_A >> handleClick: e [


	self model performAction
]

{ #category : #accessing }
SpwButton_A >> helpText [

	^ self widget helpText
]

{ #category : #accessing }
SpwButton_A >> icon [

	^ widget icon
]

{ #category : #'menus support' }
SpwButton_A >> isSelected: aBooolean [
]

{ #category : #'widget API' }
SpwButton_A >> keyStroke: anEvent fromMorph: aMorph [
]

{ #category : #'widget API' }
SpwButton_A >> label [
	self halt.
	^ self 
		buildLabel: (self presenter label withAccentuatedCharacter: self presenter shortcutCharacter) 
		withIcon: self presenter icon
]

{ #category : #updating }
SpwButton_A >> labelChanged [


	self widget label: self model label.

]

{ #category : #'widget API' }
SpwButton_A >> menu: aMenu [

	| menuPresenter |
	menuPresenter := self model contextMenu.
	menuPresenter ifNil: [ ^ nil ].
	^ SpBindings
		  value: self model application adapterBindings
		  during: [ menuPresenter build ]
]

{ #category : #factory }
SpwButton_A >> newButton [

	"Ivo Do we really need SpjButton? Isn't adapter enough?"

self halt.
	
	"	on: self
		  getState: #state
		  action: #action
		  label: #label
		  menu: #menu:"
]

{ #category : #factory }
SpwButton_A >> setWidgetColor: button [

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
SpwButton_A >> showSubMenu: aMenu [

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
SpwButton_A >> showSubMenuIfPresent [

	self model contextMenu ifNil: [ ^ self ].
	self showSubMenu: self model contextMenu
	
]

{ #category : #'widget API' }
SpwButton_A >> state [

	^ self model state
]

{ #category : #accessing }
SpwButton_A >> styleName [

	^ styleName ifNil: [ super styleName ]
]

{ #category : #accessing }
SpwButton_A >> styleName: aString [ 

	styleName := aString
]

{ #category : #updating }
SpwButton_A >> subcribeToModel [
	"how else to hook up to all possible change events of the presenter?"
	super subcribeToModel.
	self subcribeToAll:  #(color label)
]

{ #category : #updating }
SpwButton_A >> updateMenu [	
	"There is no need to updateMenu here because it will be resolved at #menu:"
]
