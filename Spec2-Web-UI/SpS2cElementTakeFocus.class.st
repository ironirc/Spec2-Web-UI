Class {
	#name : #SpS2cElementTakeFocus,
	#superclass : #SpS2cMessageWithElementId,
	#category : #'Spec2-Web-UI-serverToClientMessages'
}

{ #category : #accessing }
SpS2cElementTakeFocus >> executeInResponseContext: rc [

	self element focus
]
