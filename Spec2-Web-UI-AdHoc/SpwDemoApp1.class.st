Class {
	#name : 'SpwDemoApp1',
	#superclass : 'SpApplication',
	#instVars : [
		'context'
	],
	#category : 'Spec2-Web-UI-AdHoc',
	#package : 'Spec2-Web-UI-AdHoc'
}

{ #category : 'constants' }
SpwDemoApp1 class >> applicationName [

	^ self name asString
]

{ #category : 'instance creation' }
SpwDemoApp1 class >> defaultBackendName [

	^ #WebUI "#Morphic"
]

{ #category : 'instance creation' }
SpwDemoApp1 class >> open [

	<script>
	self new run
]

{ #category : 'accessing' }
SpwDemoApp1 >> context [

	^ context
]

{ #category : 'accessing' }
SpwDemoApp1 >> context: anObject [

	context := anObject
]

{ #category : 'accessing' }
SpwDemoApp1 >> start [

	"self windows do: [ :win | 
		win open.
		^ self ]."
	(self new: SpwDemoPresenter1) open
]
