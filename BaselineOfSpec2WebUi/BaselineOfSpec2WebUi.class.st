Class {
	#name : 'BaselineOfSpec2WebUi',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSpec2WebUi',
	#package : 'BaselineOfSpec2WebUi'
}

{ #category : 'baselines' }
BaselineOfSpec2WebUi >> baseline: spec [
	<baseline>

	self compatibility: spec.
		
	spec for: #'common' do: [
		spec postLoadDoIt: #'postload:package:'.
		self 
			prerequisites: spec;		
			packages: spec;
			groups: spec	
	]
]

{ #category : 'private - accessing' }
BaselineOfSpec2WebUi >> compatibility: spec [

	"Define a 'Compatibility' group that can be used as a dependency later to overcome differences in Pharo releases"

	
]

{ #category : 'private - accessing' }
BaselineOfSpec2WebUi >> groups: spec [

]

{ #category : 'private - accessing' }
BaselineOfSpec2WebUi >> packages: spec [

	spec
		package: 'Spec2-Web-UI-Adapters'
		with: [ spec requires: #( 'PharoXPjBasics' ) ].
	spec
		package: 'Spec2-Web-UI'
		with: [ spec requires: #( 'PharoXPjBasics' ) ].
	spec package: 'Spec2-Web-UI-AdHoc'
]

{ #category : 'baselines' }
BaselineOfSpec2WebUi >> postload: aLoader package: aPackageSpec [

	"SpwClientApp ensureRegisteredAtPjServer"
]

{ #category : 'private - accessing' }
BaselineOfSpec2WebUi >> prerequisites: spec [
	spec baseline: 'PharoXPjBasics' with: [ spec repository: 'github://ironirc/pharox-pj-basics:pharo12' ].

]
