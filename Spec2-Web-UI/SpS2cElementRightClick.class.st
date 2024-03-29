Class {
	#name : #SpS2cElementRightClick,
	#superclass : #SpS2cMessageWithElementId,
	#category : #'Spec2-Web-UI-serverToClientMessages'
}

{ #category : #private }
SpS2cElementRightClick >> executeInResponseContext: rc [

	| listener rightClick |
	listener := [ :event |
	            rc sendResponseMessage: SpS2cSimpleResponse new ].
	self element addEventListener: #contextmenu block: listener.
	rightClick := global MouseEvent new: 'contextmenu' with: {
			              ('bubbles' -> true).
			              ('cancelable' -> true).
			              ('view' -> window).
			              ('button' -> 2).
			              ('buttons' -> 2) } asJsObject.
	self element dispatchEvent: rightClick.
	self element removeEventListener: 'contextmenu' with: listener
]

{ #category : #private }
SpS2cElementRightClick >> expectsResponse [

	^ true
]
