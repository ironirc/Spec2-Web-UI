Class {
	#name : #SpS2cElementClick,
	#superclass : #SpS2cMessageWithElementId,
	#category : #'Spec2-PharoJs-serverToClientMessages'
}

{ #category : #private }
SpS2cElementClick >> executeInResponseContext: rc [

	self element click

]
