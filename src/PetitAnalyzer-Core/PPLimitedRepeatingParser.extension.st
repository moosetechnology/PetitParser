Extension { #name : #PPLimitedRepeatingParser }

{ #category : #'*petitanalyzer-matching' }
PPLimitedRepeatingParser >> copyInContext: aDictionary seen: aSeenDictionary [
	aSeenDictionary 
		at: self 
		ifPresent: [ :value | ^ value ].
	^ (aSeenDictionary at: self put: self copy)
		setParser: (parser copyInContext: aDictionary seen: aSeenDictionary);
		setLimit: (limit copyInContext: aDictionary seen: aSeenDictionary);
		yourself
]

{ #category : #'*petitanalyzer-transforming' }
PPLimitedRepeatingParser >> replace: aParser with: anotherParser [
	super replace: aParser with: anotherParser.
	limit == aParser ifTrue: [ limit := anotherParser ]
]
