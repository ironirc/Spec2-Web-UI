Class {
	#name : 'SpwPlaygroundContents',
	#superclass : 'Object',
	#category : 'Spec2-Web-UI-AdHoc',
	#package : 'Spec2-Web-UI-AdHoc'
}

{ #category : 'plagrounds' }
SpwPlaygroundContents class >> main [

	<playground>
	| app pres |
	SpwClientApp ensureRegisteredAtPjServer.
	app := SpwDemoApp1 new.
	pres := app new: SpwDemoPresenter1.
	pres open.
	SpwDemoPresenter1 new open.
	SpButtonPresenter new open.
	100 timesRepeat: [ pres tableButton1Clicked ]
]
