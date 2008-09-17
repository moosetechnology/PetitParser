Extension { #name : #Character }

{ #category : #'*petitparser' }
Character >> - aCharacter [
	"Create a range of characters between the receiver and the argument."
	
	^ PPPredicateParser between: self and: aCharacter
]
