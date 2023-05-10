Class {
	#name : #SpPharoJsApp1,
	#superclass : #SpApplication,
	#category : #'Spec2-PharoJs-AdHoc'
}

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
SpPharoJsApp1 >> start [

	^ (self new: SpPharoJsPresenter1) open
]
