Class {
	#name : 'SpwInputField_WC',
	#superclass : 'SpwAbstract_WC',
	#instVars : [
		'input',
		'selectionStart',
		'selectionEnd',
		'mouseDown',
		'value'
	],
	#category : 'Spec2-Web-UI-Adapters-WebComponents',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'WebComponents'
}

{ #category : 'constants' }
SpwInputField_WC class >> tagName [

	^ 'spw-input'
]

{ #category : 'web component callbacks' }
SpwInputField_WC >> connected [

	super connected.

]

{ #category : 'initialization' }
SpwInputField_WC >> disabled: aValue [

	input disabled: aValue
]

{ #category : 'initialization' }
SpwInputField_WC >> focus [ 

	input focus.
]

{ #category : 'initialization' }
SpwInputField_WC >> isASelectionFrom: s and: e [.
	s ifNil: [ ^false ].
	e ifNil: [ ^false ].
	^e - s >= 1 
]

{ #category : 'initialization' }
SpwInputField_WC >> readOnly: aValue [

	input readOnly: aValue
]

{ #category : 'initialization' }
SpwInputField_WC >> renderInputOn: x [

	x input: [ :el |
		input := el.
		#( placeholder type readOnly disabled ) do: [ :att |
			(self getAttribute: att) ifNotNil: [ :attVal |
				input setAttribute: att to: attVal ] ].
		x _style: {
				('height' -> '100%').
				('width' -> '100%').
				('box-sizing' -> 'border-box') }.
		input value: self value.
		x onInput: [ :e | console log: 'input -> setting value to: ' with: input value. value := input value ].
		x onChange: [ :e |console log: 'change -> setting value to: ' with: input value.  value := input value ].
		x onSelect: [ :e | self updateSelection ].
		x onMouseMove: [ :e | self updateSelection ].
		x onMouseUp: [ :e | self updateSelection ].
		x onKeyUp: [ :e | self updateSelection ].
		x onMouseDown: [ :e | mouseDown := true ].
		x onMouseUp: [ :e |
			mouseDown := false.
			window setTimeout: [ self updateSelection ] ms: 1 ].
		self setSelectionStart: 0 end: 0 ]
]

{ #category : 'initialization' }
SpwInputField_WC >> renderOn: x [

	self renderInputOn: x
]

{ #category : 'initialization' }
SpwInputField_WC >> selectionEnd [

	^selectionEnd
]

{ #category : 'initialization' }
SpwInputField_WC >> selectionStart [

	^selectionStart
]

{ #category : 'initialization' }
SpwInputField_WC >> setSelectionStart: newS end: newE [

	"towards front"

	| s e |
	mouseDown == true ifTrue: [ ^ self ].
	s := input selectionStart.
	e := input selectionEnd.
	(s = newS and: [ e = newE ]) ifTrue: [ "console log: 'nothing new'. " 
		^ self ].
	console
		log: 'setSelectionRange oldrange:'
		with: s
		with: e
		with: 'newrange:'
		with: newS
		with: newE.
	input setSelectionRange: newS end: newE
]

{ #category : 'initialization' }
SpwInputField_WC >> updateSelection [
	"towards back-end"
	| s e newEvnt somethingWasSelected somethingToBeSelected |

	s := input selectionStart.
	e := input selectionEnd.
		"console log: input with: s with: e."
	(selectionStart = s) & (selectionEnd = e) ifTrue: [ ^ self ].
	somethingWasSelected := self isASelectionFrom: selectionStart and: selectionEnd.
	somethingToBeSelected := self isASelectionFrom: s and: e.
	somethingWasSelected not  & somethingToBeSelected not ifTrue: [^self  ].

	selectionStart := s.
	selectionEnd := e.
	newEvnt := globalThis CustomEvent new: 'select'.
	self dispatchEvent: newEvnt
]

{ #category : 'initialization' }
SpwInputField_WC >> value [

	^value
]

{ #category : 'initialization' }
SpwInputField_WC >> value: aValue [

	value := aValue.
	input ifNotNil: [ input value: aValue ]
	
]
