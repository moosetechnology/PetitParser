"
A parser that parses a sequence of parsers.
"
Class {
	#name : #PPSequenceParser,
	#superclass : #PPMultipleParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPSequenceParser >> , aRule [ 
	parsers add: aRule
]

{ #category : #parsing }
PPSequenceParser >> parse: aStream [
	| position items item |
	position := aStream position.
	items := OrderedCollection new: parsers size.
	parsers do: [ :parser |
		item := parser parse: aStream.
		item isFailure ifTrue: [
			aStream position: position.
			^ item ].
		items add: item ].
	^ items asArray
]

{ #category : #printing }
PPSequenceParser >> printOn: aStream [
	aStream nextPut: $(.
	parsers
		do: [ :each | aStream print: each ]
		separatedBy: [ aStream nextPutAll: ' , ' ].
	aStream nextPut: $)
]
