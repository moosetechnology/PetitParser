Extension { #name : #PPEpsilonParser }

{ #category : #'*petitanalyzer-testing' }
PPEpsilonParser >> isNullable [
	^ true
]

{ #category : #'*petitanalyzer-matching' }
PPEpsilonParser >> match: aParser inContext: aDictionary seen: anIdentitySet [
	^ self class = aParser class
]
