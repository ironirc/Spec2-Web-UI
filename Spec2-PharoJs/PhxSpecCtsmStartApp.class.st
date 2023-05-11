Class {
	#name : #PhxSpecCtsmStartApp,
	#superclass : #PhxSpecClientToServerMessage,
	#category : #'Spec2-PharoJs'
}

{ #category : #private }
PhxSpecCtsmStartApp >> respondForRequestContext: rc [

	<pharoJsSkip>
	| app |
	"ensure instantiated application (session) for senderId""start drawing that application client side"
	
	app := SpPharoJsApp1 current. "for now work with current... later lookup"
	app context: rc.  "should create a kind of a application session instead. For now we use rc as session :-( "
	app start
]
