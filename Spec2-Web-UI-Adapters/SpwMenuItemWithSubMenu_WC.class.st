Class {
	#name : #'SpwMenuItemWithSubMenu_WC',
	#superclass : #'SpwMenuItem_WC',
	#instVars : [
		'subMenu'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #'as yet unclassified' }
SpwMenuItemWithSubMenu_WC class >> tagName [ 
	^'spw-menu-item-with-sub-menu'
]

{ #category : #accessing }
SpwMenuItemWithSubMenu_WC >> activate [  

	super activate.
	self select.
	

]

{ #category : #accessing }
SpwMenuItemWithSubMenu_WC >> cssText [ 

	^super cssText , '

.container:after {
            content: '''';
            position: absolute;
            top: 50%;
            right: 5px;
            margin-top: -5px;
            width: 0;
            height: 0;
            border-top: 5px solid transparent;
            border-bottom: 5px solid transparent;
            border-left: 10px solid #222;
}
'
]

{ #category : #accessing }
SpwMenuItemWithSubMenu_WC >> select [

	self menu selectItem: self
]

{ #category : #accessing }
SpwMenuItemWithSubMenu_WC >> subMenu [

	^ subMenu
]

{ #category : #accessing }
SpwMenuItemWithSubMenu_WC >> subMenu: anObject [

	subMenu ifNotNil: [ subMenu owner: nil ].
	subMenu := anObject.
	subMenu ifNotNil: [ subMenu owner: self ]
]
