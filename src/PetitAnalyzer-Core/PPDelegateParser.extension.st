Extension { #name : #PPDelegateParser }

{ #category : #'*petitanalyzer-matching' }
PPDelegateParser >> copyInContext: aDictionary seen: aSeenDictionary [
	aSeenDictionary 
		at: self 
		ifPresent: [ :value | ^ value ].
	^ (aSeenDictionary at: self put: self copy)
		setParser: (parser copyInContext: aDictionary seen: aSeenDictionary);
		yourself
]

{ #category : #'*petitanalyzer-transforming' }
PPDelegateParser >> replace: aParser with: anotherParser [
	super replace: aParser with: anotherParser.
	parser == aParser ifTrue: [ parser := anotherParser ]
]
