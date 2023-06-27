Class {
	#name : #BaselineOfSpec2PharoJS,
	#superclass : #BaselineOf,
	#category : #BaselineOfSpec2PharoJS
}

{ #category : #baselines }
BaselineOfSpec2PharoJS >> baseline: spec [
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

{ #category : #'private - accessing' }
BaselineOfSpec2PharoJS >> compatibility: spec [

	"Define a 'Compatibility' group that can be used as a dependency later to overcome differences in Pharo releases"

	
]

{ #category : #'private - accessing' }
BaselineOfSpec2PharoJS >> groups: spec [

]

{ #category : #'private - accessing' }
BaselineOfSpec2PharoJS >> packages: spec [

	spec
		package: 'Spec2-Adapters-PharoJs'
		with: [ spec requires: #( 'PharoXBasics' ) ].
	spec
		package: 'Spec2-PharoJs'
		with: [ spec requires: #( 'PharoXBasics' ) ].
	spec package: 'Spec2-PharoJs-AdHoc'
]

{ #category : #baselines }
BaselineOfSpec2PharoJS >> postload: aLoader package: aPackageSpec [
	
]

{ #category : #'private - accessing' }
BaselineOfSpec2PharoJS >> prerequisites: spec [
	spec baseline: 'PharoXBasics' with: [ spec repository: 'github://ironirc/pharox-pj-basics:main' ].

]
