Extension { #name : #PPLiteralParser }

{ #category : #'*petitanalyzer-matching' }
PPLiteralParser >> match: aParser inContext: aDictionary seen: anIdentitySet [
	^ self class = aParser class and: [ self literal = aParser literal ]
]
