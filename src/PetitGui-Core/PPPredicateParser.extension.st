Extension { #name : #PPPredicateParser }

{ #category : #'*petitgui-mondrian' }
PPPredicateParser >> displayName [
	^ predicateMessage
]

{ #category : #'*petitgui-accessing' }
PPPredicateParser >> exampleOn: aStream [
	| valid normal |
	valid := Character allCharacters
		select: [ :char | predicate value: char ].
	normal := valid
		select: [ :char | char asInteger < 127 and: [ char isAlphaNumeric ] ].
	aStream nextPut: (normal isEmpty
		ifTrue: [ valid atRandom ]
		ifFalse: [ normal atRandom ])
]
