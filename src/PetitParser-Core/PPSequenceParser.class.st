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

{ #category : #querying }
PPSequenceParser >> firstSets: aFirstDictionary into: aSet [
	| nullable |
	parsers do: [ :parser |
		nullable := false.
		(aFirstDictionary at: parser) do: [ :each |
			each isNullable
				ifTrue: [ nullable := true ]
				ifFalse: [ aSet add: each ] ].
		nullable
			ifFalse: [ ^ self ] ].
	aSet add: PPEpsilonParser new
]

{ #category : #querying }
PPSequenceParser >> followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet [
	parsers withIndexDo: [ :parser :index |
		| followSet firstSet |
		followSet := aFollowDictionary at: parser.
		index = parsers size
			ifTrue: [ followSet addAll: aSet ]
			ifFalse: [
				(self class withAll: (parsers 
					copyFrom: index + 1 to: parsers size))
						firstSets: aFirstDictionary
						into: (firstSet := IdentitySet new).
				(firstSet anySatisfy: [ :each | each isNullable ])
					ifTrue: [ followSet addAll: aSet ].
				followSet addAll: (firstSet 
					reject: [ :each | each isNullable ]) ] ]
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
	1 to: parsers size do: [ :index |
		element := (parsers at: index) 
			parse: aStream.
		element isFailure 
			ifFalse: [ elements at: index put: element ]
			ifTrue: [
				aStream position: start.
				^ element ] ].
	^ elements
]
