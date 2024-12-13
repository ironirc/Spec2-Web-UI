Class {
	#name : 'SpS2cCreateTabulatorTable',
	#superclass : 'SpS2cUpdateElement',
	#instVars : [
		'data',
		'columns'
	],
	#category : 'Spec2-Web-UI-serverToClientMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'serverToClientMessages'
}

{ #category : 'accessing' }
SpS2cCreateTabulatorTable >> columns [

	^ columns
]

{ #category : 'accessing' }
SpS2cCreateTabulatorTable >> columns: anObject [

	columns := anObject
]

{ #category : 'accessing' }
SpS2cCreateTabulatorTable >> data [

	^ data
]

{ #category : 'accessing' }
SpS2cCreateTabulatorTable >> data: anObject [

	data := anObject
]

{ #category : 'private' }
SpS2cCreateTabulatorTable >> tag [
	^SpwTabulator_WC tagName
]

{ #category : 'private' }
SpS2cCreateTabulatorTable >> updateElement: el builder: x [

	super updateElement: el builder: x.
	 el setColumns: self columns 
]
