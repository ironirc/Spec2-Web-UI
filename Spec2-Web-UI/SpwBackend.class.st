Class {
	#name : 'SpwBackend',
	#superclass : 'SpApplicationBackend',
	#category : 'Spec2-Web-UI-specBackEnd',
	#package : 'Spec2-Web-UI',
	#tag : 'specBackEnd'
}

{ #category : 'accessing' }
SpwBackend class >> backendName [

	^ #WebUI
]

{ #category : 'private' }
SpwBackend >> adapterBindingsClass [

	^ SpwAdapterBindings
]

{ #category : 'accessing' }
SpwBackend >> defaultConfigurationFor: anApplication [

	^ anApplication defaultConfigurationForPharoJs
]

{ #category : 'deferred message' }
SpwBackend >> defer: aBlock [

	UIManager default defer: aBlock
]

{ #category : 'deferred message' }
SpwBackend >> forceDefer: aBlock [

	UIManager default defer: aBlock
]

{ #category : 'private - notifying' }
SpwBackend >> notifyError: aSpecNotification [

	GrowlMorph
		openWithLabel: 'Error'
		contents: aSpecNotification message
		backgroundColor: GrowlMorph theme dangerBackgroundColor
		labelColor: GrowlMorph theme textColor
]

{ #category : 'private - notifying' }
SpwBackend >> notifyInfo: aSpecNotification [

	GrowlMorph 
		openWithLabel: 'Information' translated 
		contents: aSpecNotification message
]

{ #category : 'ui dialogs' }
SpwBackend >> selectDirectoryTitle: aString [

	^ UIManager default chooseDirectory: aString path: ''
]

{ #category : 'ui dialogs' }
SpwBackend >> selectFileTitle: aString [

	^ UIManager default
		  chooseExistingFileReference: aString
		  extensions: nil
		  path: ''
]

{ #category : 'display' }
SpwBackend >> showWaitCursorWhile: aBlock inApplication: anApplication [

	Cursor wait showWhile: aBlock
]
