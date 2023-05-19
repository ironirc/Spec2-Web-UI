Class {
	#name : #SpPharoJsSessionRegistry,
	#superclass : #Object,
	#classVars : [
		'sessions'
	],
	#classInstVars : [
		'dict'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #accessing }
SpPharoJsSessionRegistry class >> appAtClientId: id ifAbsentPut: aBlock [

	^ self sessions at: id ifAbsentPut: aBlock
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> prepareForNewRequest [
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> reset [
	<script>
	sessions := nil
]

{ #category : #accessing }
SpPharoJsSessionRegistry class >> sessions [
	sessions ifNil: [ sessions := Dictionary new ].
	^ sessions
]
