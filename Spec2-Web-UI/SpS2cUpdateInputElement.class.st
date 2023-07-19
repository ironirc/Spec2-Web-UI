Class {
	#name : #SpS2cUpdateInputElement,
	#superclass : #SpS2cUpdateElement,
	#instVars : [
		'readOnly',
		'selectAll',
		'type',
		'disabled',
		'selectionStart',
		'selectionEnd',
		'tag'
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
	^tag
]

{ #category : #accessing }
SpS2cUpdateInputElement >> tag: anObject [

	tag := anObject
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
SpS2cUpdateInputElement >> updateElement: el builder: x [

	super updateElement: el builder: x.
	"	readOnly ifNotNil: [ el readOnly: readOnly ]."
	"	disabled ifNotNil: [ el disabled: disabled ]."

	type ifNotNil: [ el type: type ].
	selectAll == true ifTrue: [ el select ].
	selectionStart ifNotNil: [
		selectionEnd ifNotNil: [
			el setSelectionStart: selectionStart end: selectionEnd ] ]
]
