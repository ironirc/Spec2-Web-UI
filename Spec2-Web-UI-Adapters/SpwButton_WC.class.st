Class {
	#name : 'SpwButton_WC',
	#superclass : 'SpwAbstract_WC',
	#instVars : [
		'label',
		'icon',
		'helpText'
	],
	#category : 'Spec2-Web-UI-Adapters-WebComponents',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'WebComponents'
}

{ #category : 'constants' }
SpwButton_WC class >> tagName [

	^ 'spw-button'
]

{ #category : 'rendering' }
SpwButton_WC >> cssText [  

^':host {
          display: block; /* make the custom element a block element */
        }
button {
          width: 100%; /* take up all horizontal space */
          height: 100%; /* take up all vertical space */
          color: inherit; /* inherit the color from the parent */
          background-color: inherit; /* inherit the background color from the parent */
			}
.active {
          filter: brightness(80%);  /* darken the button */
        }

'
]

{ #category : 'accessing' }
SpwButton_WC >> helpText [

	^ helpText
]

{ #category : 'accessing' }
SpwButton_WC >> helpText: anObject [

	helpText := anObject
]

{ #category : 'accessing' }
SpwButton_WC >> icon [

	^ icon
]

{ #category : 'accessing' }
SpwButton_WC >> icon: anObject [

	icon := anObject.
	self render.
]

{ #category : 'accessing' }
SpwButton_WC >> label [

	^ label
]

{ #category : 'accessing' }
SpwButton_WC >> label: anObject [

	label := anObject.
	self render.
]

{ #category : 'rendering' }
SpwButton_WC >> renderOn: x [

	x style: self cssText.
	x button: [ :btn |
		#( readOnly disabled ) do: [ :att |
			(self getAttribute: att) ifNotNil: [ :attVal |
				btn setAttribute: att to: attVal ] ].
		self icon ifNotNil: [ :i | i renderOn: x ].
		self label ifNotNil: [ x << self label ].
		x onMouseDown: [ :e |
			e button == 0 ifTrue: [
				btn classList add: 'active' ] ].
			x onMouseUp: [ :e |
			e button == 0 ifTrue: [
				btn classList remove: 'active' ] ] ].

	self helpText ifNotNil: [
		x tag: SpwTooltip_WC tagName with: [ :tt |
			tt label: self helpText.
			tt referenceElement: self ] ]
]
