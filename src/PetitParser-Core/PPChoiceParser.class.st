"
A parser that uses the first parser that succeeds.
"
Class {
	#name : #PPChoiceParser,
	#superclass : #PPMultipleParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPChoiceParser >> parse: aStream [
	| item |
	parsers do: [ :parser |
		item := parser parse: aStream.
		item isFailure
			ifFalse: [ ^ item ] ].
	^ item
]

{ #category : #printing }
PPChoiceParser >> printOn: aStream [
	aStream nextPut: $(.
	parsers
		do: [ :each | aStream print: each ]
		separatedBy: [ aStream nextPutAll: ' | ' ].
	aStream nextPut: $)
]

{ #category : #operations }
PPChoiceParser >> | aRule [ 
	parsers add: aRule
]
