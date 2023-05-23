Class {
	#name : #PhxWcSpecInputField,
	#superclass : #PjWebComponent,
	#instVars : [
		'count',
		'countElement',
		'input',
		'selectionStart',
		'selectionEnd',
		'mouseDown'
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
PhxWcSpecInputField >> focus [ 

	input focus.
	console log: 'YEAH'
]

{ #category : #initialization }
PhxWcSpecInputField >> initialize [

	count := 0
]

{ #category : #initialization }
PhxWcSpecInputField >> isASelectionFrom: s and: e [.
	s ifNil: [ ^false ].
	e ifNil: [ ^false ].
	^e - s >= 1 
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
PhxWcSpecInputField >> selectionEnd [

	^selectionEnd
]

{ #category : #initialization }
PhxWcSpecInputField >> selectionStart [

	^selectionStart
]

{ #category : #initialization }
PhxWcSpecInputField >> setSelectionStart: newS end: newE [

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
PhxWcSpecInputField >> updateSelection [
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
PhxWcSpecInputField >> value [

	^input value
]

{ #category : #initialization }
PhxWcSpecInputField >> value: aValue [

	input value: aValue
]
