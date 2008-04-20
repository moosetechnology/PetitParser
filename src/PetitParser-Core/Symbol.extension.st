Extension { #name : #Symbol }

{ #category : #'*petitparser' }
Symbol >> asParser [
	^ PPPredicateParser perform: self
]
