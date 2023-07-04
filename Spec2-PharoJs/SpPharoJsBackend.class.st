Class {
	#name : #SpPharoJsBackend,
	#superclass : #SpApplicationBackend,
	#category : #'Spec2-PharoJs-specBackEnd'
}

{ #category : #accessing }
SpPharoJsBackend class >> backendName [

	^ #PharoJs
]

{ #category : #private }
SpPharoJsBackend >> adapterBindingsClass [

	^ SpPharoJsAdapterBindings
]

{ #category : #accessing }
SpPharoJsBackend >> defaultConfigurationFor: anApplication [

	^ anApplication defaultConfigurationForPharoJs
]

{ #category : #'deferred message' }
SpPharoJsBackend >> defer: aBlock [

	UIManager default defer: aBlock
]

{ #category : #'deferred message' }
SpPharoJsBackend >> forceDefer: aBlock [

	UIManager default defer: aBlock
]

{ #category : #'private - notifying' }
SpPharoJsBackend >> notifyError: aSpecNotification [

	GrowlMorph
		openWithLabel: 'Error'
		contents: aSpecNotification message
		backgroundColor: GrowlMorph theme dangerBackgroundColor
		labelColor: GrowlMorph theme textColor
]

{ #category : #'private - notifying' }
SpPharoJsBackend >> notifyInfo: aSpecNotification [

	GrowlMorph 
		openWithLabel: 'Information' translated 
		contents: aSpecNotification message
]

{ #category : #'ui dialogs' }
SpPharoJsBackend >> selectDirectoryTitle: aString [

	^ UIManager default chooseDirectory: aString path: ''
]

{ #category : #'ui dialogs' }
SpPharoJsBackend >> selectFileTitle: aString [

	^ UIManager default
		  chooseExistingFileReference: aString
		  extensions: nil
		  path: ''
]

{ #category : #display }
SpPharoJsBackend >> showWaitCursorWhile: aBlock inApplication: anApplication [

	Cursor wait showWhile: aBlock
]
