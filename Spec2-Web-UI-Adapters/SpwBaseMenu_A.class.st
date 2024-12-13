Class {
	#name : 'SpwBaseMenu_A',
	#superclass : 'SpwAbstractAdapter',
	#category : 'Spec2-Web-UI-Adapters-Adaptors',
	#package : 'Spec2-Web-UI-Adapters',
	#tag : 'Adaptors'
}

{ #category : 'factory' }
SpwBaseMenu_A >> buildWidget [
	| rw   |
	rw := self newRemoteWidget.
	rw sendCreateMessage. 
	^ rw
]
