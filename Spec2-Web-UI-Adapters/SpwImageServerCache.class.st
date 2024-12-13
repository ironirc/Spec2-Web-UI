Class {
	#name : 'SpwImageServerCache',
	#superclass : 'Object',
	#classInstVars : [
		'cacheByForm',
		'cacheByKey'
	],
	#category : 'Spec2-Web-UI-Adapters-Table',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'Table'
}

{ #category : 'accessing' }
SpwImageServerCache class >> cacheByForm [ 

	cacheByForm ifNil: [ cacheByForm := Dictionary new ].
	^cacheByForm
]

{ #category : 'accessing' }
SpwImageServerCache class >> cacheByKey [

	cacheByKey ifNil: [ cacheByKey := Dictionary new ].
	^cacheByKey
]

{ #category : 'accessing' }
SpwImageServerCache class >> imageAtKey: aKey [

	^ self cacheByKey at: aKey
]

{ #category : 'accessing' }
SpwImageServerCache class >> imageForForm: aForm [
	^ self cacheByForm at: aForm ifAbsentPut: [
		  | newInstance |
		  newInstance := SpwImage new.
		  newInstance b64Array: (ByteArray streamContents: [ :ws |
				   PNGReadWriter putForm: aForm onStream: ws ]) base64Encoded.
		  newInstance fileExtension: 'png'.
		  newInstance cacheKey: aForm hash.
		  self cacheByKey at: newInstance cacheKey put: aForm.
		  newInstance ]
]

{ #category : 'accessing' }
SpwImageServerCache class >> resetCache [

	<script>
	cacheByForm := nil.
	cacheByKey := nil
]
