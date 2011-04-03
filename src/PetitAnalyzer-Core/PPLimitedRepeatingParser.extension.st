Extension { #name : #PPLimitedRepeatingParser }

{ #category : #'*petitanalyzer-matching' }
PPLimitedRepeatingParser >> match: aParser inContext: aDictionary seen: anIdentitySet [
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self limit match: aParser limit inContext: aDictionary seen: anIdentitySet ]
]
