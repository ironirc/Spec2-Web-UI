Class {
	#name : #PhxWcSpecInputField,
	#superclass : #PjWebComponent,
	#instVars : [
		'count',
		'countElement',
		'input',
		'selectionStart',
		'selectionEnd'
	],
	#category : #'Spec2-Adapters-PharoJs'
}

{ #category : #'as yet unclassified' }
PhxWcSpecInputField class >> tagName [

	^ 'sp-input'
]

{ #category : #initialization }
PhxWcSpecInputField >> disabled: aValue [

	input disabled: aValue
]

{ #category : #initialization }
PhxWcSpecInputField >> initialize [

	count := 0
]

{ #category : #initialization }
PhxWcSpecInputField >> readOnly: aValue [

	input readOnly: aValue
]

{ #category : #initialization }
PhxWcSpecInputField >> renderOn: x [

	x input: [ :el | 
		x _style: { 
				('height' -> '100%').
				('width' -> '100%') }.
		input := el.
		x onSelect: [ :e | self updateSelection ].
		x onMouseMove: [ :e | self updateSelection ].
		x onMouseUp: [ :e | self updateSelection ].
		x onKeyUp: [ :e | self updateSelection ] ]
]

{ #category : #initialization }
PhxWcSpecInputField >> selectionEnd [

	^selectionEnd
]

{ #category : #initialization }
PhxWcSpecInputField >> selectionStart [

	^selectionStart
]

{ #category : #initialization }
PhxWcSpecInputField >> updateSelection [

	| s e newEvnt |
	s := input selectionStart.
	e := input selectionEnd.
	(selectionStart = s) & (selectionEnd = e) ifTrue: [ ^ self ].
	selectionStart := s.
	selectionEnd := e.
	newEvnt := global CustomEvent new: 'select'.
	self dispatchEvent: newEvnt
]

{ #category : #initialization }
PhxWcSpecInputField >> value [

	^input value
]

{ #category : #initialization }
PhxWcSpecInputField >> value: aValue [

	input value: aValue
]
