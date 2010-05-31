Extension { #name : #PPRepeatingParser }

{ #category : #'*petitanalyzer-testing' }
PPRepeatingParser >> isNullable [
	^ min = 0
]

{ #category : #'*petitanalyzer-matching' }
PPRepeatingParser >> match: aParser inContext: aDictionary seen: aSet [
	^ (super match: aParser inContext: aDictionary seen: aSet) and: [ self min = aParser min and: [ self max = aParser max ] ]
]
