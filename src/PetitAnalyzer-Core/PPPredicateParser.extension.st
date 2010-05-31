Extension { #name : #PPPredicateParser }

{ #category : #'*petitanalyzer-matching' }
PPPredicateParser >> match: aParser inContext: aDictionary seen: aSet [
	^ (super match: aParser inContext: aDictionary seen: aSet) and: [ self block = aParser block and: [ self message = aParser message ] ]
]
