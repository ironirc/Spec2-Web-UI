Class {
	#name : #SpS2cUpdateInputElement,
	#superclass : #SpS2cUpdateElement,
	#instVars : [
		'readOnly',
		'selectAll',
		'type',
		'disabled',
		'visible',
		'selectionStart',
		'selectionEnd'
	],
	#category : #'Spec2-Web-UI-serverToClientMessages'
}

{ #category : #accessing }
SpS2cUpdateInputElement >> disabled [

	^ disabled
]

{ #category : #accessing }
SpS2cUpdateInputElement >> disabled: anObject [

	disabled := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> readOnly [

	^ readOnly
]

{ #category : #accessing }
SpS2cUpdateInputElement >> readOnly: anObject [

	readOnly := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectAll [

	^ selectAll
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectAll: anObject [

	selectAll := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectionEnd [

	^ selectionEnd
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectionEnd: anObject [

	selectionEnd := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectionStart [

	^ selectionStart
]

{ #category : #accessing }
SpS2cUpdateInputElement >> selectionStart: anObject [

	selectionStart := anObject
]

{ #category : #accessing }
SpS2cUpdateInputElement >> tag [
	^SpwInputField_WC tagName
]

{ #category : #accessing }
SpS2cUpdateInputElement >> type [

	^ type
]

{ #category : #accessing }
SpS2cUpdateInputElement >> type: anObject [

	type := anObject
]

{ #category : #updating }
SpS2cUpdateInputElement >> updateOn: x [

	super updateOn: x.
	readOnly ifNotNil: [ x currentElement readOnly: readOnly ].
	disabled ifNotNil: [ x currentElement disabled: disabled ].
	visible ifNotNil: [ 
		x currentElement style visibility: (visible
				 ifTrue: [ '' ]
				 ifFalse: [ 'hidden' ]) ].
	type ifNotNil: [ x currentElement type: type ].
	selectAll == true ifTrue: [ x currentElement select ].
	selectionStart ifNotNil: [ 
		selectionEnd ifNotNil: [ 
			x currentElement
				setSelectionStart: selectionStart
				end: selectionEnd ] ]
]

{ #category : #accessing }
SpS2cUpdateInputElement >> visible [

	^ visible
]

{ #category : #accessing }
SpS2cUpdateInputElement >> visible: anObject [

	visible := anObject
]
