Class {
	#name : #SpS2cCreateTabulatorTable,
	#superclass : #SpS2cUpdateElement,
	#instVars : [
		'data'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpS2cCreateTabulatorTable >> data [

	^ data
]

{ #category : #accessing }
SpS2cCreateTabulatorTable >> data: anObject [

	data := anObject
]

{ #category : #private }
SpS2cCreateTabulatorTable >> executeInResponseContext: rc [

	| el tableData x |
	el := self ensuredElementIn: rc.
	document body appendChild: el.
	x := PjDomBuilder newOnElement: el.
	self updateOn: x.

	global Tabulator new: '#' , elementId with: { 
			('height' -> '100%').
			('autoColumns' -> true).
			('data' -> data) } asJsObject
]

{ #category : #private }
SpS2cCreateTabulatorTable >> tag [
	^'div'
]
