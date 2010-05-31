Extension { #name : #PPTokenParser }

{ #category : #'*petitanalyzer-matching' }
PPTokenParser >> match: aParser inContext: aDictionary seen: aSet [
	^ (super match: aParser inContext: aDictionary seen: aSet) and: [ self tokenClass = aParser tokenClass ]
]
