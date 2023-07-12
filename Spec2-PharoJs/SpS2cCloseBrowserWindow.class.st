Class {
	#name : #SpS2cCloseBrowserWindow,
	#superclass : #SpS2cMessageWithElementId,
	#category : #'Spec2-PharoJs-serverToClientMessages'
}

{ #category : #private }
SpS2cCloseBrowserWindow >> executeInResponseContext: rc [

	window close
]
