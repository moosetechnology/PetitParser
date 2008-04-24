"
A parser that uses the first parser that succeeds.
"
Class {
	#name : #PPChoiceParser,
	#superclass : #PPListParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPChoiceParser >> basicParse: aStream [
	| item |
	parsers do: [ :parser |
		item := parser parse: aStream.
		item isFailure
			ifFalse: [ ^ item ] ].
	^ item
]

{ #category : #operations }
PPChoiceParser >> | aRule [ 
	parsers add: aRule
]
