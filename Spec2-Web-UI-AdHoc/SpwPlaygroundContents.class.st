Class {
	#name : 'SpwPlaygroundContents',
	#superclass : 'Object',
	#category : 'Spec2-Web-UI-AdHoc',
	#package : 'Spec2-Web-UI-AdHoc'
}

{ #category : 'plagrounds' }
SpwPlaygroundContents class >> main [

	<playground>
	| app |
	SpwClientApp ensureRegisteredAtPjServer.
	app := SpwDemoApp1 new.
	(app new: SpwDemoPresenter1) open.
	SpwDemoPresenter1 new open.
	SpButtonPresenter new open
]
