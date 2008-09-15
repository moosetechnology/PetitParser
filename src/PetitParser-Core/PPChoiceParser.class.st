"
A parser that uses the first parser that succeeds.
"
Class {
	#name : #PPChoiceParser,
	#superclass : #PPListParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPChoiceParser >> / aRule [ 
	parsers addLast: aRule
]

{ #category : #parsing }
PPChoiceParser >> basicParse: aStream [
	| element |
	parsers do: [ :each |
		element := each parse: aStream.
		element isFailure
			ifFalse: [ ^ element ] ].
	^ element
]
