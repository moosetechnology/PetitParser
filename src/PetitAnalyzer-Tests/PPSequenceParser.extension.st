Extension { #name : #PPSequenceParser }

{ #category : #'*petitanalyzer-private' }
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

{ #category : #'*petitanalyzer-private' }
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

{ #category : #'*petitanalyzer-private' }
PPSequenceParser >> leftRecursion: anOrderedCollection firstSets: aDictionary answer: anAnswerBlock [
	(anOrderedCollection includes: self) ifTrue: [
		anOrderedCollection first = self
			ifTrue: [ anAnswerBlock value ]
			ifFalse: [ ^ self ] ].
	anOrderedCollection addLast: self.
	parsers do: [ :parser |
		| firstSet |
		parser leftRecursion: anOrderedCollection firstSets: aDictionary answer: anAnswerBlock.
		((aDictionary at: parser) noneSatisfy: [ :each | each isNullable ])
			ifTrue: [ ^ anOrderedCollection removeLast ] ].
	anOrderedCollection removeLast
]
