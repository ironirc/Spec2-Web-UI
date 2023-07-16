Class {
	#name : #'SpwLabel_A',
	#superclass : #SpwAbstractAdapter,
	#category : #'Spec2-Web-UI-Adapters-Adaptors'
}

{ #category : #private }
SpwLabel_A >> applyDecorationsTo: aString [
	| text |

	text := aString asText.
	self presenter displayColor ifNotNil: [ :block |
		(block cull: aString) ifNotNil: [ :aColor |
		  	text addAttribute: (TextColor color: aColor) ] ].
	self presenter displayBold ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			text addAttribute: TextEmphasis bold ] ].
	self presenter displayItalic ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			text addAttribute: TextEmphasis italic ] ].
	self presenter displayUnderline ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			text addAttribute: TextEmphasis underlined ] ].
	self presenter displayBackgroundColor ifNotNil: [ :block |
		(block cull: aString) ifNotNil: [ :aColor |
		  	text addAttribute: (TextBackgroundColor color: aColor) ] ].
	
	^ text
]

{ #category : #styling }
SpwLabel_A >> applyStyle: aMorph [

"	aMorph fitContents.
	super applyStyle: aMorph."
	"when changing a font and affecting his size, it may happen than the result font 
	 height is smaller than current height of morph, we need to take care about this 
	 even if this means we cannot have a label smaller than the font :("
	"aMorph height < aMorph font height
		ifTrue: [ aMorph height: aMorph font height ]"
]

{ #category : #factory }
SpwLabel_A >> buildWidget [

"	| label |
	label := LabelMorph new model: self.
	label
		getEnabledSelector: #enabled;
		getTextSelector: #getText;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled;
		setBalloonText: self getHelpText;
		setProperty: #minWidth toValue: 3. 
	^ label"
	
	| rw msg |
	self widget ifNotNil: [ ^ self ].
	rw := self newRemoteWidget.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: rw id.
	msg tag: 'div'.
	msg textContent: self getText asString.
"	msg events: #( click )."
"	msg styles: { 
			('background-color' -> ('#' , self color asHexString))}."
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
	^ rw
]

{ #category : #private }
SpwLabel_A >> getHelpText [

	^ self presenter help ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #'model access' }
SpwLabel_A >> getText [
	^ self presenter label
		ifNotNil: [ :aString | 
			self applyDecorationsTo: (aString localizedForPresenter: self presenter) ]
]

{ #category : #accessing }
SpwLabel_A >> label [
	
	^ widget contents
]
