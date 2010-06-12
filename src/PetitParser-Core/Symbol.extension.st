Extension { #name : #Symbol }

{ #category : #'*petitparser-core-converting' }
Symbol >> asParser [
	^ PPPredicateObjectParser perform: self
]
