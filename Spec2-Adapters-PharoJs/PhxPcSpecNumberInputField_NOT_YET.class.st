Class {
	#name : #'PhxPcSpecNumberInputField_NOT_YET',
	#superclass : #PhxWcSpecInputField,
	#category : #'Spec2-Adapters-PharoJs-WebComponents'
}

{ #category : #constants }
PhxPcSpecNumberInputField_NOT_YET class >> tagName [

	^ 'sp-number-input'
]

{ #category : #initialization }
PhxPcSpecNumberInputField_NOT_YET >> renderOn: x [
x style: self style. 
	x div: [
		x _class: 'input-wrapper'.
		x input: [ :el |
			input := el.
			input id: 'input' ].
		x _html: '<div class="buttons">
    <div class="triangle-up" onclick="increment()"></div>
    <div class="triangle-down" onclick="decrement()"></div>
  </div>'
	"	x button: [
			x onClick: [ self increment ].
			x << '+' ].
		x button: [ x onClick: [ self decrement ] x << '-' ]" ]
	


]

{ #category : #initialization }
PhxPcSpecNumberInputField_NOT_YET >> style [

	^'.input-wrapper {
  display: flex;
  border: 1px solid #ccc;
  border-radius: 3px;
  overflow: hidden;
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
  height: 0;
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-bottom: 10px solid #333;
  cursor: pointer;
}

.triangle-down {
  width: 0;
  height: 0;
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-top: 10px solid #333;
  cursor: pointer;
}'
]
