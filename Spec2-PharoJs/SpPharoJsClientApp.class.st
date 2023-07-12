Class {
	#name : #SpPharoJsClientApp,
	#superclass : #PjDomController,
	#traits : 'PhxPjPromiseTrait + PhxPjLoggingTrait',
	#classTraits : 'PhxPjPromiseTrait classTrait + PhxPjLoggingTrait classTrait',
	#instVars : [
		'messenger'
	],
	#classInstVars : [
		'incrementalExporter',
		'current'
	],
	#category : #'Spec2-PharoJs-client'
}

{ #category : #css }
SpPharoJsClientApp class >> addCssReset [

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
SpPharoJsClientApp class >> appClasses [

	<pharoJsSkip>
	^ SpS2cMessage withAllSubclasses , SpC2sEvent withAllSubclasses , {
		  PhxSpaResponse.
		  PhxWcSpecInputField.
		  PhxWcSpecTabulator.
		  SpTabulatorColumn.
		  SpPharoJsImage }
	
]

{ #category : #pharojs }
SpPharoJsClientApp class >> appLaunchBlock [

	| appClass |
	appClass := self.
	^ [ appClass yourself ] asClosedBlock
]

{ #category : #pharojs }
SpPharoJsClientApp class >> appPackages [
	<pharoJsSkip>
	^ #()
]

{ #category : #css }
SpPharoJsClientApp class >> appendStyleElementToHeadWith: aString [
	| style |
	style := self createElement: 'style'.
	style innerHTML: aString.
	self document head js_appendChild: style.
	^ style
]

{ #category : #constants }
SpPharoJsClientApp class >> applicationName [
	^'spec'
]

{ #category : #private }
SpPharoJsClientApp class >> boot [

	window addEventListener: #load block: [ 
		self addCssReset.
		self showSplashScreen.
		self promiseAllExternalResourcesLoaded then: [ 
			self body innerHTML: ''.
			self current messenger setupConnectionWithServer ] ]
]

{ #category : #accessing }
SpPharoJsClientApp class >> clientId [

	^ PhxBrowserPersistentClientId value
]

{ #category : #'instance creation' }
SpPharoJsClientApp class >> current [
	current ifNil: [ current := self new ].
	^current
]

{ #category : #server }
SpPharoJsClientApp class >> currentUrl [

	<pharoJsSkip>
	^ String streamContents: [ :ws |
		  ws << 'http://localhost:' << ZnServer default port printString << self httpPath ].

]

{ #category : #server }
SpPharoJsClientApp class >> exporterClass [
	<pharoJsSkip>
	^ PjExporter
]

{ #category : #pharojs }
SpPharoJsClientApp class >> headerLine [
	^ nil
]

{ #category : #server }
SpPharoJsClientApp class >> htmlPageWithInitialScript [
	<pharoJsSkip>
	"self incrementalExporter reset."
	"self incrementalExporter javascriptCode"
	^ self htmlPageWithJsScript:  nil 
]

{ #category : #pharojs }
SpPharoJsClientApp class >> htmlPageWithJsScript: aScript [
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
<script type="text/javascript" src="https://unpkg.com/tabulator-tables@5.5.0/dist/js/tabulator.min.js"></script>
 <style>*, *:before, *:after {
    box-sizing: border-box;
	}</style>
  </head>
  <body id="body">
  </body>
</html>' ]
]

{ #category : #server }
SpPharoJsClientApp class >> httpPath [ 
	^'/' , self applicationName
]

{ #category : #server }
SpPharoJsClientApp class >> initialScript [
	<pharoJsSkip>
	^ (PjExporter newWithAppClass: self) javascriptCode , self name  , '.pj_boot();'
]

{ #category : #server }
SpPharoJsClientApp class >> newAppContext [
	<pharoJsSkip>
	^nil
]

{ #category : #server }
SpPharoJsClientApp class >> newServerWebSocketHandler [

	<pharoJsSkip>
	| wsh |
	wsh := PhxServerWebSocketHandler new.
	wsh applicationClass: self.
	wsh context: SpPharoJsSessionRegistry.
	^ wsh
]

{ #category : #'instance creation' }
SpPharoJsClientApp class >> openBrowserWithStartId: startId [

	WebBrowser
		openOn: (String streamContents: [ :ws |
				 ws << self currentUrl << '?startId=' << startId ])
		inBackground: false
]

{ #category : #pharojs }
SpPharoJsClientApp class >> pharoJsSelectorPrefix [
	^ 'pj_'
]

{ #category : #pharojs }
SpPharoJsClientApp class >> polyfill: aClass withTranspiler: aPjDependentTranspiler unlessIn: aCollection [ 
	
]

{ #category : #private }
SpPharoJsClientApp class >> promiseAllExternalResourcesLoaded [

	^ self promiseResolve: nil
]

{ #category : #css }
SpPharoJsClientApp class >> promiseCssReset [

	^self promise: [ :resolve :reject | 
		self addCssReset.
		resolve value ]
]

{ #category : #'instance creation' }
SpPharoJsClientApp class >> registerAsApplicationAtPjServer [
	<pharoJsSkip>
	<script>
	PhxPjServer registerApplication: self
]

{ #category : #pharojs }
SpPharoJsClientApp class >> setupCode [
	<pharoJsSkip>
	^ '	var global=global ?? this'
]

{ #category : #private }
SpPharoJsClientApp class >> showSplashScreen [

	| x |
	x := PjDomBuilder newOnElement: self body.
	x div: self applicationName , ' is loading...'
]

{ #category : #accessing }
SpPharoJsClientApp class >> webSocketPath [ 
	^self httpPath , '-ws'
]

{ #category : #'accessing derived' }
SpPharoJsClientApp >> dialogManager [

	^ self
]

{ #category : #initialization }
SpPharoJsClientApp >> initialize [

	super initialize.
	self logSelfAndAll: { 'initialize' }
]

{ #category : #components }
SpPharoJsClientApp >> messenger [

	messenger ifNil: [ 
		messenger := PhxClientWebSocketHandler new.
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
SpPharoJsClientApp >> onWebSocketOpen: ev [
	

	| msg |
	msg := SpC2sStartOrResumeApp new.
"	msg clientId: PhxBrowserPersistentClientId value.
	msg sessionId: PhxBrowserExpiringSessionId value."
	msg windowId: PhxBrowserWindowId value.
	msg urlSessionId: self urlParameterStartId.
	(self messenger promiseResponseFor: msg) then: [ :rc | self log: rc msg. document body innerHTML: 'Yeah'  ]
]

{ #category : #components }
SpPharoJsClientApp >> promiseAppSession [
	<pharoJsSkip>
	^ self promise: [ :resolve :reject | 
		  | msg |
		  self logAll: { 'sending start app session to server' }.
		  msg := SpC2sStartAppSession new.
		  msg clientId: PhxBrowserPersistentClientId value.
		  msg sessionId: PhxBrowserExpiringSessionId value.
"		  msg windowId: PhxBrowserWindowId value."
		  self messenger
			  sendMessageToServer: msg
			  onResponseDo: [ :env | 
				  | sessionId |
				  self logAll: { 
						  'receiving session envelope:'.
						  env }.
				  sessionId := env msg payload.
				  PhxBrowserExpiringSessionId
					  value: sessionId
					  expireInSeconds: 3600.
				  resolve value: sessionId ]
			  isResponseToIncomingEnvelope: nil ]
]

{ #category : #'server messaging' }
SpPharoJsClientApp >> urlParameterStartId [ 

	| url |
	url := global URL new: document location.
	^url searchParams get: 'startId'

]

{ #category : #'server messaging' }
SpPharoJsClientApp >> webSocketUrl [
	| protocol |
	protocol := window location protocol = 'https:'
		ifTrue: 'wss://'
		ifFalse: [ 'ws://' ].
	
	^ protocol , window location host , self class webSocketPath 
]
