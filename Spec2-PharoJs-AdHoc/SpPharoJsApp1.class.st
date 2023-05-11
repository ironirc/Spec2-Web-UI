Class {
	#name : #SpPharoJsApp1,
	#superclass : #SpApplication,
	#instVars : [
		'context'
	],
	#classInstVars : [
		'current'
	],
	#category : #'Spec2-PharoJs-AdHoc'
}

{ #category : #'instance creation' }
SpPharoJsApp1 class >> current [

	current ifNil: [ current := self new ].
	^ current
]

{ #category : #'instance creation' }
SpPharoJsApp1 class >> defaultBackendName [

	^ #PharoJs
]

{ #category : #'instance creation' }
SpPharoJsApp1 class >> open [

	<script>
	self new run
]

{ #category : #accessing }
SpPharoJsApp1 >> context [

	^ context
]

{ #category : #accessing }
SpPharoJsApp1 >> context: anObject [

	context := anObject
]

{ #category : #accessing }
SpPharoJsApp1 >> start [

	^ (self new: SpPharoJsPresenter1) open
]
