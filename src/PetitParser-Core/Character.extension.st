Extension { #name : #Character }

{ #category : #'*petitparser-core-operators' }
Character >> - aCharacter [
	"Create a range of characters between the receiver and the argument."
	
	^ PPPredicateObjectParser between: self and: aCharacter
]

{ #category : #'*petitparser-converting' }
Character >> asParser [
	^ PPLiteralObjectParser on: self
]
