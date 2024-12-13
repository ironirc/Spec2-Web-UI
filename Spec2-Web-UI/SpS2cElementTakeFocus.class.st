Class {
	#name : 'SpS2cElementTakeFocus',
	#superclass : 'SpS2cMessageWithElementId',
	#category : 'Spec2-Web-UI-serverToClientMessages',
	#package : 'Spec2-Web-UI',
	#tag : 'serverToClientMessages'
}

{ #category : 'accessing' }
SpS2cElementTakeFocus >> executeInResponseContext: rc [

	self element focus
]
