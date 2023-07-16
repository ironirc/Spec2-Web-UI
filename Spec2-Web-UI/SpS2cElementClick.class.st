Class {
	#name : #SpS2cElementClick,
	#superclass : #SpS2cMessageWithElementId,
	#category : #'Spec2-Web-UI-serverToClientMessages'
}

{ #category : #private }
SpS2cElementClick >> executeInResponseContext: rc [

	| listener |
	listener := [ :event |
	            rc sendResponseMessage: SpS2cSimpleResponse new ].
	self element addEventListener: #click block: listener.
	self element click.
	self element removeEventListener: #click with: listener
]

{ #category : #private }
SpS2cElementClick >> expectsResponse [

	^ true
]
