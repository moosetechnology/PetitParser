Extension { #name : #Symbol }

{ #category : #'*petitparser-core-converting' }
Symbol >> asParser [
	"Answers a predicate parser named after the receving symbol. Possible symbols are the method selectors on the class-side of PPPredicateObjectParser."

	^ PPPredicateObjectParser perform: self
]
