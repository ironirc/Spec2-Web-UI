Class {
	#name : #SpPharoJsClientSideApp,
	#superclass : #PjDomController,
	#traits : 'PhxPromiseTrait + PhxLoggingTrait',
	#classTraits : 'PhxPromiseTrait classTrait + PhxLoggingTrait classTrait',
	#instVars : [
		'messenger'
	],
	#classInstVars : [
		'incrementalExporter'
	],
	#category : #'Spec2-PharoJs'
}

{ #category : #css }
SpPharoJsClientSideApp class >> addCssReset [

	<phxCss>
	self appendStyleElementToHeadWith: '
html, body {
font-family: -apple-system, BlinkMacSystemFont,
    “Segoe UI”, “Roboto”, “Oxygen”, “Ubuntu”, “Cantarell”,
    “Fira Sans”, “Droid Sans”, “Helvetica Neue”,
    sans-serif;
  box-sizing: border-box;
}
/* Box sizing rules */
*,
*::before,
*::after {
  box-sizing: border-box;
}

/* Remove default margin */
body,
h1,
h2,
h3,
h4,
p,
figure,
blockquote,
dl,
dd {
  margin: 0;
}

/* Remove list styles on ul, ol elements with a list role, which suggests default styling will be removed */
ul[role="list"],
ol[role="list"] {
  list-style: none;
}

/* Set core root defaults */
html:focus-within {
  scroll-behavior: smooth;
}

/* Set core body defaults */
body {
  font-size: 1rem;
  font-weight: 400;
  color: #212529;
  min-height: 100vh;
  text-rendering: optimizeSpeed;
  line-height: 1.2;
  -webkit-text-size-adjust: 100%;
  -webkit-tap-highlight-color: transparent;
}
 
/* A elements that don"t have a class get default styles */
a:not([class]) {
  text-decoration-skip-ink: auto;
}

/* Make images easier to work with */
img,
picture {
  max-width: 100%;
  display: block;
}

/* Inherit fonts for inputs and buttons */
input,
button,
textarea,
select {
  font: inherit;
}

/* Remove all animations and transitions for people that prefer not to see them */
@media (prefers-reduced-motion: reduce) {
  html:focus-within {
   scroll-behavior: auto;
  }
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}'
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> appClasses [
	<pharoJsSkip>
	^ {SpStcmAddDivTest}
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> appLaunchBlock [
	^[]
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> appPackages [
	<pharoJsSkip>
	^ #()
]

{ #category : #constants }
SpPharoJsClientSideApp class >> applicationName [
	^'spec'
]

{ #category : #private }
SpPharoJsClientSideApp class >> boot [

	window addEventListener: #load block: [ 
		self showSplashScreen.
		self promiseAllExternalResourcesLoaded then: [ 
			self body innerHTML: 'Loaded! '. self new messenger setupConnectionWithServer ] ]
]

{ #category : #accessing }
SpPharoJsClientSideApp class >> clientId [
	(localStorage getItem: 'clientId') ifNil: [ 
		localStorage
			setItem: 'clientId'
			value: PhxSpaUtils randomStringSize10 ].
	^ localStorage getItem: 'clientId'
]

{ #category : #server }
SpPharoJsClientSideApp class >> exporterClass [
	<pharoJsSkip>
	^ PjExporter
]

{ #category : #accessing }
SpPharoJsClientSideApp class >> handleSystemAnnouncement: ann withWebSocketMessageHandler: wsmh [

	| jsCode aClass |
	"Every instance knows it's exorter (via applicationClass), and should do this routine seperately"
	aClass := ann classAffected.
	aClass := self incrementalExporter exporter transpiler
		          convertedClasses asOrderedCollection
		          detect: [ :cls | 
			          cls = aClass or: [ "[T#000373] auto push method changes to client does not work for class side methods" 
				          cls classSide = aClass ] ]
		          ifNone: [ ^ self ].
	[ 
	| successMsg updateViewMsg msg |
	jsCode := self incrementalExporter exporter convertAllClassesToJs:
		          { aClass }.
	msg := PhxSpaExeExecuteCode javascript: jsCode.
	wsmh boadcastMessage: msg.

	"This code should be responsibility within comp23. Please remove here."
	ann affectsMethods ifTrue: [ 
		(ann method pragmaAt: #phxCss) ifNotNil: [ 
			| js |
			js := self incrementalExporter jsForObjectOrBlock: [ 
				      PhxC23Component initializeAllCss ].
			msg := PhxSpaExeExecuteCode javascript: js.
			wsmh boadcastMessage: msg ] ].


	"This code should be responsibility within comp23. Please remove here."
	updateViewMsg := PhxSpaStcUpdateEntireComponentView new.
	wsmh boadcastMessage: updateViewMsg.
	successMsg := PhxSpaStcRaiseMessageToast new.
	successMsg message: 'Successfully handled '.
	wsmh boadcastMessage: successMsg ]
		on: Error
		do: [ :ex | 
			| msg |
			msg := PhxSpaStcRaiseErrorToast new.
			msg message: ex messageText.
			wsmh boadcastMessage: msg.
			ex return: nil ]
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> headerLine [
	^ nil
]

{ #category : #server }
SpPharoJsClientSideApp class >> htmlPageWithInitialScript [
	<pharoJsSkip>
	self incrementalExporter reset.
	^ self htmlPageWithJsScript: self incrementalExporter initialScript
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> htmlPageWithJsScript: aScript [
	<pharoJsSkip>
	^ String streamContents: [ :ws | 
		  ws << '<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, maximum-scale=2.0, user-scalable=yes"
    />
	<script type="text/javascript" src="' << self applicationName << '.js"></script>
  </head>
  <body>
    
  </body>
</html>' ]
]

{ #category : #server }
SpPharoJsClientSideApp class >> httpPath [ 
	^'/' , self applicationName
]

{ #category : #server }
SpPharoJsClientSideApp class >> incrementalExporter [
	<pharoJsSkip>
	incrementalExporter ifNil: [ 
		incrementalExporter := PhxPjIncrementalExporterWithCache new.
		incrementalExporter applicationClass: self ].
	^ incrementalExporter
]

{ #category : #server }
SpPharoJsClientSideApp class >> newAppContext [
	<pharoJsSkip>
	^nil
]

{ #category : #server }
SpPharoJsClientSideApp class >> newWebSocketHandler [

	<pharoJsSkip>
	| wsh |
	wsh := PhxWebSocketMessageHandler new.
	wsh applicationClass: self.
	^ wsh
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> pharoJsSelectorPrefix [
	^ 'pj_'
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> polyfill: aClass withTranspiler: aPjDependentTranspiler unlessIn: aCollection [ 
	
]

{ #category : #private }
SpPharoJsClientSideApp class >> promiseAllExternalResourcesLoaded [

	^ self promiseResolve: nil
]

{ #category : #css }
SpPharoJsClientSideApp class >> promiseCssReset [

	^self promise: [ :resolve :reject | 
		self addCssReset.
		resolve value ]
]

{ #category : #'instance creation' }
SpPharoJsClientSideApp class >> registerAsApplicationAtPjServer [
	<pharoJsSkip>
	<script>
	PhxPjServer registerApplication: self
]

{ #category : #pharojs }
SpPharoJsClientSideApp class >> setupCode [
	<pharoJsSkip>
	^ '	var global=global ?? this'
]

{ #category : #private }
SpPharoJsClientSideApp class >> showSplashScreen [

	| x |
	x := PjDomBuilderReactive "PhxC23Builder" newOnElement: self body.
	x div: self applicationName , ' is loading...'
]

{ #category : #accessing }
SpPharoJsClientSideApp class >> webSocketPath [ 
	^self httpPath , '-ws'
]

{ #category : #'accessing derived' }
SpPharoJsClientSideApp >> dialogManager [

	^ self
]

{ #category : #initialization }
SpPharoJsClientSideApp >> initialize [

	super initialize.
	self logSelfAndAll: { 'initialize' }
]

{ #category : #components }
SpPharoJsClientSideApp >> messenger [

	messenger ifNil: [ 
		messenger := PhxSpaWebSocketMessenger new.
		messenger webSocketUrl: self webSocketUrl.
		messenger tokenProvider: nil.
		messenger client: self.
		messenger onEvent: PhxPseWebSocketOpened do: [ :ev | 
			self log: 'Websocket has been opened.'.
			self onWebSocketOpen: ev payload ].
		messenger
			onEvent: PhxPseWebSocketClosed
			do: [ :ev | self log: 'Websocket has been closed.' ] ].
	^ messenger
]

{ #category : #components }
SpPharoJsClientSideApp >> onWebSocketOpen: ev [

	| msg |
	msg := PhxSpecCtsmStartApp new. 
 
	self messenger sendMessageToServer: msg.
]

{ #category : #'server messaging' }
SpPharoJsClientSideApp >> webSocketUrl [
	| protocol |
	protocol := window location protocol = 'https:'
		ifTrue: 'wss://'
		ifFalse: [ 'ws://' ].
	
	^ protocol , window location host , self class webSocketPath 
]
