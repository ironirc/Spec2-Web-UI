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

{ #category : #constants }
SpPharoJsApp1 class >> applicationName [

	^ self name asString
]

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

{ #category : #'instance creation' }
SpPharoJsApp1 class >> reset [

	<script>
	self current reset
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
