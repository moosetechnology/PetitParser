Extension { #name : #PPRepeatingParser }

{ #category : #'*petitanalyzer-testing' }
PPRepeatingParser >> isNullable [
	^ min = 0
]

{ #category : #'*petitanalyzer-matching' }
PPRepeatingParser >> match: aParser inContext: aDictionary seen: anIdentitySet [
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self min = aParser min and: [ self max = aParser max ] ]
]
