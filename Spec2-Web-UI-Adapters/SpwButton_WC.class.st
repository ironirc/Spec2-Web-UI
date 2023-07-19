Class {
	#name : #'SpwButton_WC',
	#superclass : #'SpwAbstract_WC',
	#instVars : [
		'label'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #constants }
SpwButton_WC class >> tagName [

	^ 'spw-button'
]

{ #category : #rendering }
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
button:active {
          filter: brightness(80%);  /* darken the button */
        }'
]

{ #category : #accessing }
SpwButton_WC >> label [

	^ label
]

{ #category : #accessing }
SpwButton_WC >> label: anObject [

	label := anObject.
	self render.
]

{ #category : #rendering }
SpwButton_WC >> renderOn: x [
	x style: self cssText.
	x button: [ :btn |
		#( readOnly disabled ) do: [ :att |
			(self getAttribute: att) ifNotNil: [ :attVal |
				btn setAttribute: att to: attVal ] ].
		self label ifNotNil: [ x << self label ] ]
]
