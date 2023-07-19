Class {
	#name : #SpwApp1,
	#superclass : #SpApplication,
	#instVars : [
		'context'
	],
	#category : #'Spec2-Web-UI-AdHoc'
}

{ #category : #constants }
SpwApp1 class >> applicationName [

	^ self name asString
]

{ #category : #'instance creation' }
SpwApp1 class >> defaultBackendName [

	^ #WebUI "#Morphic"
]

{ #category : #'instance creation' }
SpwApp1 class >> open [

	<script>
	self new run
]

{ #category : #accessing }
SpwApp1 >> context [

	^ context
]

{ #category : #accessing }
SpwApp1 >> context: anObject [

	context := anObject
]

{ #category : #accessing }
SpwApp1 >> start [

	self windows do: [ :win | 
		win open.
		^ self ].
	(self new: SpwPresenter1) open
]
