Class {
	#name : #SpPharoJsLabelAdapter,
	#superclass : #SpAbstractPharoJsAdapter,
	#category : #'Spec2-Adapters-PharoJs-Base'
}

{ #category : #private }
SpPharoJsLabelAdapter >> applyDecorationsTo: aString [
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
SpPharoJsLabelAdapter >> applyStyle: aMorph [

"	aMorph fitContents.
	super applyStyle: aMorph."
	"when changing a font and affecting his size, it may happen than the result font 
	 height is smaller than current height of morph, we need to take care about this 
	 even if this means we cannot have a label smaller than the font :("
	"aMorph height < aMorph font height
		ifTrue: [ aMorph height: aMorph font height ]"
]

{ #category : #factory }
SpPharoJsLabelAdapter >> buildWidget [

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
	
	| id msg |
	self widget ifNotNil: [ ^ self ].
	id := self class nextIdString.
	msg := SpS2cUpdateArbitraryElement new.
	msg elementId: id.
	msg tag: 'div'.
	msg textContent: self getText asString.
"	msg events: #( click )."
"	msg styles: { 
			('background-color' -> ('#' , self color asHexString))}."
	msg attributes: { ('ph-src' -> thisContext method printString) }.
	self sendMessageToClient: msg.
	^ id
]

{ #category : #private }
SpPharoJsLabelAdapter >> getHelpText [

	^ self presenter help ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #'model access' }
SpPharoJsLabelAdapter >> getText [
	^ self presenter label
		ifNotNil: [ :aString | 
			self applyDecorationsTo: (aString localizedForPresenter: self presenter) ]
]

{ #category : #accessing }
SpPharoJsLabelAdapter >> label [
	
	^ widget contents
]
