Class {
	#name : #'SpwInputField_WC',
	#superclass : #PjWebComponent,
	#instVars : [
		'count',
		'countElement',
		'input',
		'selectionStart',
		'selectionEnd',
		'mouseDown'
	],
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #constants }
SpwInputField_WC class >> tagName [

	^ 'spw-input'
]

{ #category : #'web component callbacks' }
SpwInputField_WC >> connected [

	super connected.
	#( placeholder type ) do: [ :name |
		input setAttribute: name to: (self getAttribute: name) ]
]

{ #category : #initialization }
SpwInputField_WC >> disabled: aValue [

	input disabled: aValue
]

{ #category : #initialization }
SpwInputField_WC >> focus [ 

	input focus.
]

{ #category : #initialization }
SpwInputField_WC >> initialize [

	count := 0
]

{ #category : #initialization }
SpwInputField_WC >> isASelectionFrom: s and: e [.
	s ifNil: [ ^false ].
	e ifNil: [ ^false ].
	^e - s >= 1 
]

{ #category : #initialization }
SpwInputField_WC >> readOnly: aValue [

	input readOnly: aValue
]

{ #category : #initialization }
SpwInputField_WC >> renderOn: x [

	x input: [ :el | 
		x _style: { 
				('height' -> '100%').
				('width' -> '100%').
				('box-sizing' -> 'border-box') }.
		input := el.
		x onSelect: [ :e | self updateSelection ].
		x onMouseMove: [ :e | self updateSelection ].
		x onMouseUp: [ :e | self updateSelection ].
		x onKeyUp: [ :e | self updateSelection ].
		x onMouseDown: [ :e | mouseDown := true ].
		x onMouseUp: [ :e | 
			mouseDown := false.
			window setTimeout: [ self updateSelection ] ms: 0 ] ]
]

{ #category : #initialization }
SpwInputField_WC >> selectionEnd [

	^selectionEnd
]

{ #category : #initialization }
SpwInputField_WC >> selectionStart [

	^selectionStart
]

{ #category : #initialization }
SpwInputField_WC >> setSelectionStart: newS end: newE [

	"FW"

	| s e |
	mouseDown == true ifTrue: [ ^ self ].
	s := input selectionStart.
	e := input selectionEnd.
	(s = newS and: [ e = newE ]) ifTrue: [ "console log: 'nothing new'. " 
		^ self ].
	"console
		log: 'old'
		with: s
		with: e
		with: 'new'
		with: newS
		with: newE."
	input setSelectionRange: newS end: newE
]

{ #category : #initialization }
SpwInputField_WC >> updateSelection [
	"BW"
	| s e newEvnt somethingWasSelected somethingToBeSelected |
	s := input selectionStart.
	e := input selectionEnd.
	(selectionStart = s) & (selectionEnd = e) ifTrue: [ ^ self ].
	somethingWasSelected := self isASelectionFrom: selectionStart and: selectionEnd.
	somethingToBeSelected := self isASelectionFrom: s and: e.
	somethingWasSelected not  & somethingToBeSelected not ifTrue: [^self  ].
	selectionStart := s.
	selectionEnd := e.
	newEvnt := global CustomEvent new: 'select'.
	self dispatchEvent: newEvnt
]

{ #category : #initialization }
SpwInputField_WC >> value [

	^input value
]

{ #category : #initialization }
SpwInputField_WC >> value: aValue [

	input value: aValue
]
