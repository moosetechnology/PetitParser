Extension { #name : #PPActionParser }

{ #category : #'*petitanalyzer-matching' }
PPActionParser >> match: aParser inContext: aDictionary seen: anIdentitySet [
	"This is the default implementation to match two parsers. This code can properly handle recursion. This is code is supposed to be overridden in subclasses that add new state."

	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block ]
]
