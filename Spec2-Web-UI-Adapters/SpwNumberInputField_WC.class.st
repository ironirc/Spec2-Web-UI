Class {
	#name : #'SpwNumberInputField_WC',
	#superclass : #'SpwInputField_WC',
	#category : #'Spec2-Web-UI-Adapters-WebComponents'
}

{ #category : #constants }
SpwNumberInputField_WC class >> tagName [

	^ 'spw-number-input'
]

{ #category : #initialization }
SpwNumberInputField_WC >> cssText [

	^'.input-wrapper {
  display: flex;
  border: 1px solid #ccc;
  border-radius: 3px;
  overflow: hidden;
  height: 100%;
  width: 100%;
  box-sizing: border-box;
}

.input-wrapper input {
  flex-grow: 1;
  border: none;
  padding: 5px;
  outline: none;
}

.buttons {
  display: flex;
  flex-direction: column;
}

.triangle-up {
  width: 0;
  height: 40%;
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-bottom: 10px solid #333;
  cursor: pointer;
	margin-bottom: 2px;
}

.triangle-down {
  width: 0;
  height: 40%;
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-top: 10px solid #333;
  cursor: pointer;
	margin-top: 2px;
}'
]

{ #category : #initialization }
SpwNumberInputField_WC >> renderOn_notYet: x [

	x style: self cssText.
	x div: [
		x _class: 'input-wrapper'.
		self renderInputOn: x.
		x div: [
			x _class: 'buttons'.
			x div: [
				x _class: 'triangle-up'.
				x onClick: [ self increment ] ].
			x div: [
				x _class: 'triangle-down'.
				x onClick: [ self decrement ] ] ] ]
]

{ #category : #initialization }
SpwNumberInputField_WC >> setSelectionStart: newS end: newE [
]
