Extension { #name : #Character }

{ #category : #'*petitparser-core-operators' }
Character >> - aCharacter [
	"Create a range of characters between the receiver and the argument."
	
	^ PPPredicateParser between: self and: aCharacter
]
