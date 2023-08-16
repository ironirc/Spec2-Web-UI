Class {
	#name : #'SpwBaseMenu_A',
	#superclass : #SpwAbstractAdapter,
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #factory }
SpwBaseMenu_A >> buildWidget [
	| rw   |
	rw := self newRemoteWidget.
	rw sendCreateMessage. 
	^ rw
]
