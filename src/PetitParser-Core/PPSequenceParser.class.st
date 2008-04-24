"
A parser that parses a sequence of parsers.
"
Class {
	#name : #PPSequenceParser,
	#superclass : #PPListParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPSequenceParser >> , aRule [ 
	parsers add: aRule
]

{ #category : #parsing }
PPSequenceParser >> basicParse: aStream [
	| index item items position |
	index := 1.
	position := aStream position.
	items := Array new: parsers size.
	parsers do: [ :parser |
		item := parser parse: aStream.
		item isFailure ifTrue: [
			aStream position: position.
			^ item ].
		items at: index put: item.
		index := index + 1 ].
	^ items
]
