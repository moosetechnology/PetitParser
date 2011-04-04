Extension { #name : #PPLimitedRepeatingParser }

{ #category : #'*petitanalyzer-matching' }
PPLimitedRepeatingParser >> match: aParser inContext: aDictionary seen: anIdentitySet [
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self limit match: aParser limit inContext: aDictionary seen: anIdentitySet ]
]

{ #category : #'*petitanalyzer-transforming' }
PPLimitedRepeatingParser >> replace: aParser with: anotherParser [
	super replace: aParser with: anotherParser.
	limit == aParser ifTrue: [ limit := anotherParser ]
]
