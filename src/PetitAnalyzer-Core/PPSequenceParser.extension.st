Extension { #name : #PPSequenceParser }

{ #category : #'*petitanalyzer-querying' }
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

{ #category : #'*petitanalyzer-querying' }
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
