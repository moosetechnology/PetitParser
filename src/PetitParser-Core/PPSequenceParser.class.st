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
PPSequenceParser >> parse: aStream [
	| start elements element |
	start := aStream position.
	elements := Array new: parsers size.
	parsers keysAndValuesDo: [ :index :each |
		element := each parse: aStream.
		element isFailure 
			ifFalse: [ elements at: index put: element ]
			ifTrue: [
				aStream position: start.
				^ element ] ].
	^ elements
]
