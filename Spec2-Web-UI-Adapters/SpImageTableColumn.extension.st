Extension { #name : #SpImageTableColumn }

{ #category : #'*Spec2-Web-UI-Adapters' }
SpImageTableColumn >> asTabulatorColumnWithIndex: i [

	| col |
	col := SpwTabulatorColumn new.
	col title: self title.
	col field: 'col' , i printString.
	col index: i.
	col type: #Base64Jpg.
	col formatter: 'image'.
	self displayAlignment ifNotNil: [ :da |
		col horizontalAlignment: (da value: nil) asTabulatorAlignment ].
	^ col
"	

{title:""Example"", field:""example"", formatter:""image"", formatterParams:{
    height:""50px"",
    width:""50px"",
    urlPrefix:""http://website.com/images/"",
    urlSuffix:"".png"",
}}"
]

{ #category : #'*Spec2-Web-UI-Adapters' }
SpImageTableColumn >> getValueFor: anObject id: id tableAdaptor: tableAdaptor [
	"^tableAdaptor getValueFor: anObject id: id stringColumn: self"

	| form result |
	form := self evaluation value: anObject.
	""
	result := SpwImage new.
	result b64Array: (ByteArray streamContents: [ :ws |
			 "PluginBasedJPEGReadWriter" PNGReadWriter  putForm: form onStream: ws ])
			base64Encoded.
	result fileExtension: 'png'.
	result cacheKey: nil. "to be done"
	^ result
]
