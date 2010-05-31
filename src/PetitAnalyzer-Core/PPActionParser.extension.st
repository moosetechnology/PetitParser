Extension { #name : #PPActionParser }

{ #category : #'*petitanalyzer-matching' }
PPActionParser >> match: aParser inContext: aDictionary seen: aSet [
	^ (super match: aParser inContext: aDictionary seen: aSet) and: [ self block = aParser block ]
]
