Extension { #name : #PPPredicateSequenceParser }

{ #category : #'*petitanalyzer-matching' }
PPPredicateSequenceParser >> match: aParser inContext: aDictionary seen: aSet [
	^ (super match: aParser inContext: aDictionary seen: aSet) and: [ self size = aParser size ]
]
