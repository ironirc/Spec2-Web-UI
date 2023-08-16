Class {
	#name : #SpwClientApp,
	#superclass : #PjDomController,
	#traits : 'PhxPjPromiseTrait + PhxPjLoggingTrait',
	#classTraits : 'PhxPjPromiseTrait classTrait + PhxPjLoggingTrait classTrait',
	#instVars : [
		'messenger',
		'sessionId',
		'nodeCache'
	],
	#classInstVars : [
		'incrementalExporter',
		'current',
		'initialScript'
	],
	#category : #'Spec2-Web-UI-client'
}

{ #category : #css }
SpwClientApp class >> addCssReset [

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

{ #category : #css }
SpwClientApp class >> addCssSnackBar [

	<phxCss>
	self appendStyleElementToHeadWith: self snackBarCss
]

{ #category : #css }
SpwClientApp class >> addJsSnackBar [

	
	global eval:  self snackBarJs 
	

]

{ #category : #private }
SpwClientApp class >> afterExportApp [
]

{ #category : #pharojs }
SpwClientApp class >> appClasses [

	<pharoJsSkip>
	^ SpS2cMessage withAllSubclasses , SpC2sEvent withAllSubclasses
	  , SpwAbstract_WC withAllSubclasses , {
		  PhxSpaResponse.
		  SpwTabulatorColumn.
		  SpwImage }
]

{ #category : #pharojs }
SpwClientApp class >> appLaunchBlock [

	| appClass |
	appClass := self.
	^ [ appClass yourself ] asClosedBlock
]

{ #category : #pharojs }
SpwClientApp class >> appPackages [
	<pharoJsSkip>
	^ #()
]

{ #category : #css }
SpwClientApp class >> appendStyleElementToHeadWith: aString [
	| style |
	style := self createElement: 'style'.
	style innerHTML: aString.
	self document head js_appendChild: style.
	^ style
]

{ #category : #constants }
SpwClientApp class >> applicationName [
	^'spec'
]

{ #category : #private }
SpwClientApp class >> beforeExportApp [
]

{ #category : #private }
SpwClientApp class >> boot [

	window addEventListener: #load block: [ 
		self addCssReset.
		self addCssSnackBar.
		self addJsSnackBar.
		self showSplashScreen.
		self promiseAllExternalResourcesLoaded then: [ 
			self body innerHTML: ''.
			self current messenger setupConnectionWithServer ] ]
]

{ #category : #accessing }
SpwClientApp class >> clientId [

	^ PhxBrowserPersistentClientId value
]

{ #category : #'instance creation' }
SpwClientApp class >> current [
	current ifNil: [ current := self new ].
	^current
]

{ #category : #server }
SpwClientApp class >> currentUrl [

	<pharoJsSkip>
	^ String streamContents: [ :ws |
		  ws << 'http://localhost:' << ZnServer default port printString << self httpPath ].

]

{ #category : #'instance creation' }
SpwClientApp class >> ensureRegisteredAtPjServer [

	<pharoJsSkip>
	<script>
	[ PhxPjServer registerApplication: self ]
		on: Error
		do: [ :ex |
			PhxPjServer startDefaultZnServer.
			PhxPjServer registerApplication: self ]
]

{ #category : #server }
SpwClientApp class >> exporterClass [
	<pharoJsSkip>
	^ PjExporter
]

{ #category : #private }
SpwClientApp class >> handleSystemAnnouncement: ann [
	<pharoJsSkip>
	initialScript := nil
]

{ #category : #pharojs }
SpwClientApp class >> headerLine [
	^ nil
]

{ #category : #server }
SpwClientApp class >> htmlPageWithInitialScript [
	<pharoJsSkip>
	"self incrementalExporter reset."
	"self incrementalExporter javascriptCode"
	^ self htmlPageWithJsScript:  nil 
]

{ #category : #pharojs }
SpwClientApp class >> htmlPageWithJsScript: aScript [
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
 <style>*, *:before, *:after {
    box-sizing: border-box;
	}</style>
	<script type="text/javascript" src="https://unpkg.com/tabulator-tables@5.5.0/dist/js/tabulator.min.js"></script>
	<script src="https://unpkg.com/@popperjs/core@2"></script>
	<script src="https://unpkg.com/tippy.js@6"></script>
<script src="https://cdn.jsdelivr.net/npm/@floating-ui/core@1.4.0"></script>
<script src="https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.5.0"></script>
	<script type="text/javascript" src="' << self applicationName << '.js"></script>
  </head>
  <body id="body">
  </body>
</html>' ]
]

{ #category : #server }
SpwClientApp class >> httpPath [ 
	^'/' , self applicationName
]

{ #category : #server }
SpwClientApp class >> initialScript [
<script>
	<pharoJsSkip>
	initialScript ifNil: [
		initialScript := (PjExporter newWithAppClass: self) javascriptCode
		                 , self name , '.pj_boot();' ].
	^ initialScript
]

{ #category : #server }
SpwClientApp class >> newAppContext [
	<pharoJsSkip>
	^nil
]

{ #category : #server }
SpwClientApp class >> newServerWebSocketHandler [

	<pharoJsSkip>
	| wsh |
	wsh := PhxServerWebSocketHandler new.
	wsh applicationClass: self.
	"wsh context: SpPharoJsSessionRegistry."
	^ wsh
]

{ #category : #'instance creation' }
SpwClientApp class >> openBrowserWithStartId: startId [

	WebBrowser
		openOn: (String streamContents: [ :ws |
				 ws << self currentUrl << '?startId=' << startId ])
		inBackground: false
]

{ #category : #pharojs }
SpwClientApp class >> pharoJsSelectorPrefix [
	^ 'pj_'
]

{ #category : #pharojs }
SpwClientApp class >> polyfill: aClass withTranspiler: aPjDependentTranspiler unlessIn: aCollection [ 
	
]

{ #category : #private }
SpwClientApp class >> promiseAllExternalResourcesLoaded [

	^ self promiseResolve: nil
]

{ #category : #css }
SpwClientApp class >> promiseCssReset [

	^self promise: [ :resolve :reject | 
		self addCssReset.
		resolve value ]
]

{ #category : #pharojs }
SpwClientApp class >> setupCode [
	<pharoJsSkip>
	^ '	var global=global ?? this'
]

{ #category : #private }
SpwClientApp class >> showSplashScreen [

	| x |
	x := PjDomBuilder newOnElement: self body.
	x div: self applicationName , ' is loading...'
]

{ #category : #css }
SpwClientApp class >> snackBarCss [

^'.js-snackbar-container{position:absolute;bottom:0;right:0;display:flex;flex-direction:column;align-items:flex-end;max-width:100%;z-index:999;overflow:hidden}.js-snackbar-container--top-left{bottom:unset;right:unset;top:0;left:0}.js-snackbar-container--top-center{top:0;bottom:unset;left:50%;right:unset;transform:translateX(-50%)}.js-snackbar-container--top-right{bottom:unset;right:0;left:unset;top:0}.js-snackbar-container--bottom-left{bottom:0;right:unset;left:0;top:unset}.js-snackbar-container--bottom-center{bottom:0;right:unset;left:50%;top:unset;transform:translateX(-50%)}.js-snackbar-container--fixed{position:fixed}.js-snackbar-container *{box-sizing:border-box}.js-snackbar__wrapper{overflow:hidden;height:auto;margin:0;border-radius:3px;display:flex;min-width:auto;transition-property:all;transition-timing-function:ease;transition-duration:.5s}.js-snackbar{display:inline-flex;box-sizing:border-box;border-radius:3px;color:#eee;font-size:16px;background-color:#262626;vertical-align:bottom;box-shadow:0 0 4px 0 #000;margin:0 10px;flex-grow:1}.js-snackbar__close,.js-snackbar__message-wrapper,.js-snackbar__status{position:relative}.js-snackbar__message-wrapper{flex:1;padding:12px}.js-snackbar__message{display:inline-block}.js-snackbar__status{display:none;min-width:15px;margin-right:5px;border-radius:3px 0 0 3px;background-color:transparent}.js-snackbar__status.js-snackbar--danger,.js-snackbar__status.js-snackbar--info,.js-snackbar__status.js-snackbar--success,.js-snackbar__status.js-snackbar--warning{display:flex;justify-content:center;align-items:center}.js-snackbar__status.js-snackbar--success{background-color:#4caf50}.js-snackbar__status.js-snackbar--warning{background-color:#ff9800}.js-snackbar__status.js-snackbar--danger{background-color:#b90909}.js-snackbar__status.js-snackbar--info{background-color:#2196f3}.js-snackbar__icon{display:flex;justify-content:center;align-items:center;border:2px solid #fff;font-weight:700;border-radius:20px;height:20px;width:20px;text-align:center;margin:0 5px;font-family:monospace}.js-snackbar__action{display:flex;align-items:center;padding:0 10px;color:#838cff;cursor:pointer}.js-snackbar__action:hover{background-color:#333}.js-snackbar__close{cursor:pointer;display:flex;align-items:center;padding:0 10px;user-select:none;color:#bbb}.js-snackbar__close:hover{background-color:#444}
/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIi4uL3NyYy9qcy1zbmFja2Jhci5jc3MiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsdUJBQ0ksaUJBQWtCLENBQ2xCLFFBQVMsQ0FDVCxPQUFRLENBQ1IsWUFBYSxDQUNiLHFCQUFzQixDQUN0QixvQkFBcUIsQ0FDckIsY0FBZSxDQUNmLFdBQVksQ0FDWixlQUNKLENBRUEsaUNBQ0ksWUFBYSxDQUNiLFdBQVksQ0FDWixLQUFNLENBQ04sTUFDSixDQUVBLG1DQUNJLEtBQU0sQ0FDTixZQUFhLENBQ2IsUUFBUyxDQUNULFdBQVksQ0FDWiwwQkFDSixDQUVBLGtDQUNJLFlBQWEsQ0FDYixPQUFRLENBQ1IsVUFBVyxDQUNYLEtBQ0osQ0FFQSxvQ0FDSSxRQUFTLENBQ1QsV0FBWSxDQUNaLE1BQU8sQ0FDUCxTQUNKLENBRUEsc0NBQ0ksUUFBUyxDQUNULFdBQVksQ0FDWixRQUFTLENBQ1QsU0FBVSxDQUNWLDBCQUNKLENBRUEsOEJBQ0ksY0FDSixDQUVBLHlCQUNJLHFCQUNKLENBRUEsc0JBQ0ksZUFBZ0IsQ0FDaEIsV0FBWSxDQUNaLFFBQVMsQ0FDVCxpQkFBa0IsQ0FDbEIsWUFBYSxDQUNiLGNBQWUsQ0FDZix1QkFBd0IsQ0FDeEIsK0JBQWdDLENBQ2hDLHVCQUNKLENBRUEsYUFDSSxtQkFBb0IsQ0FDcEIscUJBQXNCLENBQ3RCLGlCQUFrQixDQUNsQixVQUFXLENBQ1gsY0FBZSxDQUNmLHdCQUF5QixDQUN6QixxQkFBc0IsQ0FDdEIseUJBQTJCLENBQzNCLGFBQWMsQ0FDZCxXQUNKLENBRUEsdUVBR0ksaUJBQ0osQ0FFQSw4QkFDSSxNQUFPLENBQ1AsWUFDSixDQUVBLHNCQUNJLG9CQUNKLENBRUEscUJBQ0ksWUFBYSxDQUNiLGNBQWUsQ0FDZixnQkFBaUIsQ0FDakIseUJBQTBCLENBQzFCLDRCQUNKLENBRUMsb0tBSUcsWUFBYSxDQUNiLHNCQUF1QixDQUN2QixrQkFDSixDQUVBLDBDQUNJLHdCQUNKLENBRUEsMENBQ0ksd0JBQ0osQ0FFQyx5Q0FDRyx3QkFDSixDQUVDLHVDQUNHLHdCQUNKLENBRUEsbUJBQ0ksWUFBYSxDQUNiLHNCQUF1QixDQUN2QixrQkFBbUIsQ0FDbkIscUJBQXVCLENBQ3ZCLGVBQWlCLENBQ2pCLGtCQUFtQixDQUNuQixXQUFZLENBQ1osVUFBVyxDQUNYLGlCQUFrQixDQUNsQixZQUFhLENBQ2IscUJBQ0osQ0FFQSxxQkFDSSxZQUFhLENBQ2Isa0JBQW1CLENBQ25CLGNBQWUsQ0FDZixhQUFjLENBQ2QsY0FDSixDQUVBLDJCQUNJLHFCQUNKLENBRUEsb0JBQ0ksY0FBZSxDQUNmLFlBQWEsQ0FDYixrQkFBbUIsQ0FDbkIsY0FBZSxDQUNmLGdCQUFpQixDQUNqQixVQUNKLENBRUEsMEJBQ0kscUJBQ0oiLCJmaWxlIjoianMtc25hY2tiYXIubWluLmNzcyIsInNvdXJjZXNDb250ZW50IjpbIi5qcy1zbmFja2Jhci1jb250YWluZXIge1xyXG4gICAgcG9zaXRpb246IGFic29sdXRlO1xyXG4gICAgYm90dG9tOiAwO1xyXG4gICAgcmlnaHQ6IDA7XHJcbiAgICBkaXNwbGF5OiBmbGV4O1xyXG4gICAgZmxleC1kaXJlY3Rpb246IGNvbHVtbjtcclxuICAgIGFsaWduLWl0ZW1zOiBmbGV4LWVuZDtcclxuICAgIG1heC13aWR0aDogMTAwJTtcclxuICAgIHotaW5kZXg6IDk5OTtcclxuICAgIG92ZXJmbG93OiBoaWRkZW47XHJcbn1cclxuXHJcbi5qcy1zbmFja2Jhci1jb250YWluZXItLXRvcC1sZWZ0IHtcclxuICAgIGJvdHRvbTogdW5zZXQ7XHJcbiAgICByaWdodDogdW5zZXQ7XHJcbiAgICB0b3A6IDA7XHJcbiAgICBsZWZ0OiAwO1xyXG59XHJcblxyXG4uanMtc25hY2tiYXItY29udGFpbmVyLS10b3AtY2VudGVyIHtcclxuICAgIHRvcDogMDtcclxuICAgIGJvdHRvbTogdW5zZXQ7XHJcbiAgICBsZWZ0OiA1MCU7XHJcbiAgICByaWdodDogdW5zZXQ7XHJcbiAgICB0cmFuc2Zvcm06IHRyYW5zbGF0ZVgoLTUwJSk7XHJcbn1cclxuXHJcbi5qcy1zbmFja2Jhci1jb250YWluZXItLXRvcC1yaWdodCB7XHJcbiAgICBib3R0b206IHVuc2V0O1xyXG4gICAgcmlnaHQ6IDA7XHJcbiAgICBsZWZ0OiB1bnNldDtcclxuICAgIHRvcDogMDtcclxufVxyXG5cclxuLmpzLXNuYWNrYmFyLWNvbnRhaW5lci0tYm90dG9tLWxlZnQge1xyXG4gICAgYm90dG9tOiAwO1xyXG4gICAgcmlnaHQ6IHVuc2V0O1xyXG4gICAgbGVmdDogMDtcclxuICAgIHRvcDogdW5zZXQ7XHJcbn1cclxuXHJcbi5qcy1zbmFja2Jhci1jb250YWluZXItLWJvdHRvbS1jZW50ZXIge1xyXG4gICAgYm90dG9tOiAwO1xyXG4gICAgcmlnaHQ6IHVuc2V0O1xyXG4gICAgbGVmdDogNTAlO1xyXG4gICAgdG9wOiB1bnNldDtcclxuICAgIHRyYW5zZm9ybTogdHJhbnNsYXRlWCgtNTAlKTtcclxufVxyXG5cclxuLmpzLXNuYWNrYmFyLWNvbnRhaW5lci0tZml4ZWQge1xyXG4gICAgcG9zaXRpb246IGZpeGVkO1xyXG59XHJcblxyXG4uanMtc25hY2tiYXItY29udGFpbmVyICoge1xyXG4gICAgYm94LXNpemluZzogYm9yZGVyLWJveDtcclxufVxyXG5cclxuLmpzLXNuYWNrYmFyX193cmFwcGVyIHtcclxuICAgIG92ZXJmbG93OiBoaWRkZW47XHJcbiAgICBoZWlnaHQ6IGF1dG87XHJcbiAgICBtYXJnaW46IDA7XHJcbiAgICBib3JkZXItcmFkaXVzOiAzcHg7XHJcbiAgICBkaXNwbGF5OiBmbGV4O1xyXG4gICAgbWluLXdpZHRoOiBhdXRvO1xyXG4gICAgdHJhbnNpdGlvbi1wcm9wZXJ0eTogYWxsO1xyXG4gICAgdHJhbnNpdGlvbi10aW1pbmctZnVuY3Rpb246IGVhc2U7XHJcbiAgICB0cmFuc2l0aW9uLWR1cmF0aW9uOiAwLjVzO1xyXG59XHJcblxyXG4uanMtc25hY2tiYXIge1xyXG4gICAgZGlzcGxheTogaW5saW5lLWZsZXg7XHJcbiAgICBib3gtc2l6aW5nOiBib3JkZXItYm94O1xyXG4gICAgYm9yZGVyLXJhZGl1czogM3B4O1xyXG4gICAgY29sb3I6ICNlZWU7XHJcbiAgICBmb250LXNpemU6IDE2cHg7XHJcbiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjMjYyNjI2O1xyXG4gICAgdmVydGljYWwtYWxpZ246IGJvdHRvbTtcclxuICAgIGJveC1zaGFkb3c6IDAgMCA0cHggMCBibGFjaztcclxuICAgIG1hcmdpbjogMCAxMHB4O1xyXG4gICAgZmxleC1ncm93OiAxO1xyXG59XHJcblxyXG4uanMtc25hY2tiYXJfX2Nsb3NlLFxyXG4uanMtc25hY2tiYXJfX3N0YXR1cyxcclxuLmpzLXNuYWNrYmFyX19tZXNzYWdlLXdyYXBwZXIge1xyXG4gICAgcG9zaXRpb246IHJlbGF0aXZlO1xyXG59XHJcblxyXG4uanMtc25hY2tiYXJfX21lc3NhZ2Utd3JhcHBlciB7XHJcbiAgICBmbGV4OiAxO1xyXG4gICAgcGFkZGluZzogMTJweDtcclxufVxyXG5cclxuLmpzLXNuYWNrYmFyX19tZXNzYWdlIHtcclxuICAgIGRpc3BsYXk6IGlubGluZS1ibG9jaztcclxufVxyXG5cclxuLmpzLXNuYWNrYmFyX19zdGF0dXMge1xyXG4gICAgZGlzcGxheTogbm9uZTtcclxuICAgIG1pbi13aWR0aDogMTVweDtcclxuICAgIG1hcmdpbi1yaWdodDogNXB4O1xyXG4gICAgYm9yZGVyLXJhZGl1czogM3B4IDAgMCAzcHg7XHJcbiAgICBiYWNrZ3JvdW5kLWNvbG9yOiB0cmFuc3BhcmVudDtcclxufVxyXG5cclxuIC5qcy1zbmFja2Jhcl9fc3RhdHVzLmpzLXNuYWNrYmFyLS1zdWNjZXNzLFxyXG4gLmpzLXNuYWNrYmFyX19zdGF0dXMuanMtc25hY2tiYXItLXdhcm5pbmcsXHJcbiAuanMtc25hY2tiYXJfX3N0YXR1cy5qcy1zbmFja2Jhci0tZGFuZ2VyLFxyXG4gLmpzLXNuYWNrYmFyX19zdGF0dXMuanMtc25hY2tiYXItLWluZm8ge1xyXG4gICAgZGlzcGxheTogZmxleDtcclxuICAgIGp1c3RpZnktY29udGVudDogY2VudGVyO1xyXG4gICAgYWxpZ24taXRlbXM6IGNlbnRlcjtcclxufVxyXG5cclxuLmpzLXNuYWNrYmFyX19zdGF0dXMuanMtc25hY2tiYXItLXN1Y2Nlc3MgIHtcclxuICAgIGJhY2tncm91bmQtY29sb3I6ICM0Y2FmNTA7XHJcbn1cclxuXHJcbi5qcy1zbmFja2Jhcl9fc3RhdHVzLmpzLXNuYWNrYmFyLS13YXJuaW5nICB7XHJcbiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjZmY5ODAwO1xyXG59XHJcblxyXG4gLmpzLXNuYWNrYmFyX19zdGF0dXMuanMtc25hY2tiYXItLWRhbmdlciB7XHJcbiAgICBiYWNrZ3JvdW5kLWNvbG9yOiAjYjkwOTA5O1xyXG59XHJcblxyXG4gLmpzLXNuYWNrYmFyX19zdGF0dXMuanMtc25hY2tiYXItLWluZm8ge1xyXG4gICAgYmFja2dyb3VuZC1jb2xvcjogIzIxOTZmMztcclxufVxyXG5cclxuLmpzLXNuYWNrYmFyX19pY29uIHtcclxuICAgIGRpc3BsYXk6IGZsZXg7XHJcbiAgICBqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjtcclxuICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7XHJcbiAgICBib3JkZXI6IDJweCBzb2xpZCB3aGl0ZTtcclxuICAgIGZvbnQtd2VpZ2h0OiBib2xkO1xyXG4gICAgYm9yZGVyLXJhZGl1czogMjBweDtcclxuICAgIGhlaWdodDogMjBweDtcclxuICAgIHdpZHRoOiAyMHB4O1xyXG4gICAgdGV4dC1hbGlnbjogY2VudGVyO1xyXG4gICAgbWFyZ2luOiAwIDVweDtcclxuICAgIGZvbnQtZmFtaWx5OiBtb25vc3BhY2U7XHJcbn1cclxuXHJcbi5qcy1zbmFja2Jhcl9fYWN0aW9uIHtcclxuICAgIGRpc3BsYXk6IGZsZXg7XHJcbiAgICBhbGlnbi1pdGVtczogY2VudGVyO1xyXG4gICAgcGFkZGluZzogMCAxMHB4O1xyXG4gICAgY29sb3I6ICM4MzhjZmY7XHJcbiAgICBjdXJzb3I6IHBvaW50ZXI7XHJcbn1cclxuXHJcbi5qcy1zbmFja2Jhcl9fYWN0aW9uOmhvdmVyIHtcclxuICAgIGJhY2tncm91bmQtY29sb3I6ICMzMzM7XHJcbn1cclxuXHJcbi5qcy1zbmFja2Jhcl9fY2xvc2Uge1xyXG4gICAgY3Vyc29yOiBwb2ludGVyO1xyXG4gICAgZGlzcGxheTogZmxleDtcclxuICAgIGFsaWduLWl0ZW1zOiBjZW50ZXI7XHJcbiAgICBwYWRkaW5nOiAwIDEwcHg7XHJcbiAgICB1c2VyLXNlbGVjdDogbm9uZTtcclxuICAgIGNvbG9yOiAjQkJCO1xyXG59XHJcblxyXG4uanMtc25hY2tiYXJfX2Nsb3NlOmhvdmVyIHtcclxuICAgIGJhY2tncm91bmQtY29sb3I6ICM0NDQ7XHJcbn0iXX0= */'
]

{ #category : #css }
SpwClientApp class >> snackBarJs [

^'function SnackBar(userOptions){var _This=this;var _Interval;var _Element;var _Container;var _Message;var _MessageWrapper;function _create(){_applyUserOptions();_setContainer();_applyPositionClasses();_Element=_createMessage();_Container.appendChild(_Element);if(_Options.timeout!==false&&_Options.timeout>0){_Interval=setTimeout(_This.Close,_Options.timeout)}}function _applyUserOptions(){_Options={message:userOptions?.message??"Operation performed successfully.",dismissible:userOptions?.dismissible??true,timeout:userOptions?.timeout??5000,status:userOptions?.status?userOptions.status.toLowerCase().trim():"",actions:userOptions?.actions??[],fixed:userOptions?.fixed??false,position:userOptions?.position??"br",container:userOptions?.container??document.body,width:userOptions?.width,speed:userOptions?.speed,icon:userOptions?.icon}}function _setContainer(){var target=getOrFindContainer();if(target===undefined){console.warn("SnackBar: Could not find target container "+_Options.container);target=document.body;// default to the body as the container
}_Container=getOrAddContainerIn(target);function getOrAddContainerIn(target){var node;var positionClass=_getPositionClass();for(var i=0;i<target.children.length;i++){node=target.children.item(i);if(node.nodeType===1&&node.classList.length>0&&node.classList.contains("js-snackbar-container")&&node.classList.contains(positionClass)){return node}}return createNewContainer(target)}function createNewContainer(target){var container=document.createElement("div");container.classList.add("js-snackbar-container");if(_Options.fixed){container.classList.add("js-snackbar-container--fixed")}target.appendChild(container);return container}function getOrFindContainer(){return typeof _Options.container==="string"?document.querySelector(_Options.container):_Options.container}}function _applyPositionClasses(){_Container.classList.add(_getPositionClass());var fixedClassName="js-snackbar-container--fixed";if(_Options.fixed){_Container.classList.add(fixedClassName)}else{_Container.classList.remove(fixedClassName)}}function _createMessage(){var outerElement=createWrapper();var innerSnack=createInnerSnackbar();outerElement.appendChild(innerSnack);return outerElement;function createWrapper(){var outerElement=document.createElement("div");outerElement.classList.add("js-snackbar__wrapper");outerElement.style.height="0px";outerElement.style.opacity="0";outerElement.style.marginTop="0px";outerElement.style.marginBottom="0px";setWidth(outerElement);setSpeed(outerElement);return outerElement}function createInnerSnackbar(){var innerSnack=document.createElement("div");innerSnack.classList.add("js-snackbar","js-snackbar--show");applyColorAndIconTo(innerSnack);insertMessageTo(innerSnack);addActionsTo(innerSnack);addDismissButtonTo(innerSnack);return innerSnack}function applyColorAndIconTo(element){if(!_Options.status)return;var status=document.createElement("span");status.classList.add("js-snackbar__status");applyColorTo(status);applyIconTo(status);element.appendChild(status);function applyColorTo(element){switch(_Options.status){case"success":case"green":element.classList.add("js-snackbar--success");break;case"warning":case"alert":case"orange":element.classList.add("js-snackbar--warning");break;case"danger":case"error":case"red":element.classList.add("js-snackbar--danger");break;default:element.classList.add("js-snackbar--info");break;}}function applyIconTo(element){if(!_Options.icon)return;var icon=document.createElement("span");icon.classList.add("js-snackbar__icon");switch(_Options.icon){case"exclamation":case"warn":case"danger":icon.innerText="!";break;case"info":case"question":case"question-mark":icon.innerText="?";break;case"plus":case"add":icon.innerText="+";break;default:if(_Options.icon.length>1){console.warn("Invalid icon character provided: ",_Options.icon)}icon.innerText=_Options.icon.substr(0,1);break;}element.appendChild(icon)}}function insertMessageTo(element){_MessageWrapper=document.createElement("div");_MessageWrapper.classList.add("js-snackbar__message-wrapper");_Message=document.createElement("span");_Message.classList.add("js-snackbar__message");_Message.innerHTML=_Options.message;_MessageWrapper.appendChild(_Message);element.appendChild(_MessageWrapper)}function addActionsTo(element){if(typeof _Options.actions!=="object"){return}for(var i=0;i<_Options.actions.length;i++){addAction(element,_Options.actions[i])}function addAction(element,action){var button=document.createElement("span");button.classList.add("js-snackbar__action");button.textContent=action.text;if(typeof action.function==="function"){if(action.dismiss===true){button.onclick=function(){action.function();_This.Close()}}else{button.onclick=action.function}}else{button.onclick=_This.Close}element.appendChild(button)}}function addDismissButtonTo(element){if(!_Options.dismissible){return}var closeButton=document.createElement("span");closeButton.classList.add("js-snackbar__close");closeButton.innerText="\xD7";closeButton.onclick=_This.Close;element.appendChild(closeButton)}function setWidth(element){if(!_Options.width)return;element.style.width=_Options.width}function setSpeed(element){const{speed}=_Options;switch(typeof speed){case"number":element.style.transitionDuration=speed+"ms";break;case"string":element.style.transitionDuration=speed;break;}}}function _getPositionClass(){switch(_Options.position){case"bl":return"js-snackbar-container--bottom-left";case"tl":return"js-snackbar-container--top-left";case"tr":return"js-snackbar-container--top-right";case"tc":case"tm":return"js-snackbar-container--top-center";case"bc":case"bm":return"js-snackbar-container--bottom-center";default:return"js-snackbar-container--bottom-right";}}this.Open=function(){var contentHeight=getMessageHeight();_Element.style.height=contentHeight+"px";_Element.style.opacity=1;_Element.style.marginTop="5px";_Element.style.marginBottom="5px";_Element.addEventListener("transitioned",function(){_Element.removeEventListener("transitioned",arguments.callee);_Element.style.height=null});function getMessageHeight(){const wrapperStyles=window.getComputedStyle(_MessageWrapper);return _Message.scrollHeight+parseFloat(wrapperStyles.getPropertyValue("padding-top"))+parseFloat(wrapperStyles.getPropertyValue("padding-bottom"))}};this.Close=function(){if(_Interval)clearInterval(_Interval);var snackbarHeight=_Element.scrollHeight;// get the auto height as a px value
var snackbarTransitions=_Element.style.transition;_Element.style.transition="";requestAnimationFrame(function(){_Element.style.height=snackbarHeight+"px";// set the auto height to the px height
_Element.style.opacity=1;_Element.style.marginTop="0px";_Element.style.marginBottom="0px";_Element.style.transition=snackbarTransitions;requestAnimationFrame(function(){_Element.style.height="0px";_Element.style.opacity=0})});setTimeout(function(){_Container.removeChild(_Element)},1000)};_create();_This.Open()}if(typeof module!=="undefined"){module.exports=SnackBar}'
]

{ #category : #private }
SpwClientApp class >> subscribeToSystemAnnouncer [

	<script>
	<pharoJsSkip>
	self unsubscribeFromSystemAnnouncer.
	SystemAnnouncer uniqueInstance weak
		when: ClassAdded , ClassModifiedClassDefinition , ClassRemoved
			, ClassRenamed , MethodAdded , MethodModified , MethodRemoved
		send: #handleSystemAnnouncement:
		to: self
]

{ #category : #private }
SpwClientApp class >> unsubscribeFromSystemAnnouncer [

	<script>
	<pharoJsSkip>
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #accessing }
SpwClientApp class >> webSocketPath [ 
	^self httpPath , '-ws'
]

{ #category : #'accessing derived' }
SpwClientApp >> dialogManager [

	^ self
]

{ #category : #initialization }
SpwClientApp >> initialize [

	super initialize.
	self logSelfAndAll: { 'initialize' }.
	nodeCache := Dictionary new
]

{ #category : #components }
SpwClientApp >> messenger [

	messenger ifNil: [
		messenger := PhxClientWebSocketHandler new.
		messenger webSocketUrl: self webSocketUrl.
		messenger tokenProvider: nil.
		messenger client: self.
		messenger onEvent: PhxPseWebSocketOpened do: [ :ev |
			self log: 'Websocket has been opened.'.
			self snackBarSuccess: 'websocket opened'.
			self onWebSocketOpen: ev payload ].
		messenger onEvent: PhxPseWebSocketClosed do: [ :ev |
			self snackBarError: 'websocket closed'.
			self log: 'Websocket has been closed.' ] ].
	^ messenger
]

{ #category : #'accessing derived' }
SpwClientApp >> nodeAt: key put: node [

	^ nodeCache at: key put: node
]

{ #category : #'accessing derived' }
SpwClientApp >> nodeCache [

	^ nodeCache
]

{ #category : #'accessing derived' }
SpwClientApp >> nodeOrNilAt: key [

	^ nodeCache at: key ifAbsent: [ nil ]
]

{ #category : #components }
SpwClientApp >> onWebSocketOpen: ev [

	| msg |
	msg := SpC2sStartSession new.
	msg sessionId: self urlParameterStartId.
	(self messenger promiseResponseFor: msg) then: [ :rc |
		rc msg isSuccess
			ifTrue: [ self snackBarSuccess: rc msg message ]
			ifFalse: [ self snackBarError: rc msg message ] ]
]

{ #category : #'accessing derived' }
SpwClientApp >> removeKey: key [

	nodeCache removeKey: key
]

{ #category : #components }
SpwClientApp >> snackBarError: msg [

	self snackBarMessage: msg status: 'error'
]

{ #category : #components }
SpwClientApp >> snackBarMessage: msg [

	self snackBarMessage: msg status: nil
]

{ #category : #components }
SpwClientApp >> snackBarMessage: msg status: status [

	global SnackBar new: {
			('message' -> msg).
			('position' -> 'bl').
			('status' -> status) } asJsObject
]

{ #category : #components }
SpwClientApp >> snackBarSuccess: msg [

	self snackBarMessage: msg status: 'success'
]

{ #category : #'server messaging' }
SpwClientApp >> urlParameterStartId [ 

	| url |
	url := global URL new: document location.
	^url searchParams get: 'startId'

]

{ #category : #'server messaging' }
SpwClientApp >> webSocketUrl [
	| protocol |
	protocol := window location protocol = 'https:'
		ifTrue: 'wss://'
		ifFalse: [ 'ws://' ].
	
	^ protocol , window location host , self class webSocketPath 
]
