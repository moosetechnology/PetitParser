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
	^ self copyWith: aRule
]

{ #category : #operations }
PPSequenceParser >> map: aBlock [
	^ self ==> [ :nodes | aBlock valueWithArguments: nodes ]
]

{ #category : #parsing }
PPSequenceParser >> parseOn: aStream [
	| start elements element |
	start := aStream position.
	elements := Array new: parsers size.
	1 to: parsers size do: [ :index |
		element := (parsers at: index) 
			parseOn: aStream.
		element isPetitFailure 
			ifFalse: [ elements at: index put: element ]
			ifTrue: [
				aStream position: start.
				^ element ] ].
	^ elements
]

{ #category : #operations }
PPSequenceParser >> permutation: anArrayOfIntegers [
	"Answer a permutation of the receivers sequence."
	
	anArrayOfIntegers do: [ :index |
		(index isInteger and: [ index between: 1 and: parsers size ])
			ifFalse: [ self error: 'Invalid permutation index: ' , index printString ] ].
	^ self ==> [ :nodes | anArrayOfIntegers collect: [ :index | nodes at: index ] ]
]
