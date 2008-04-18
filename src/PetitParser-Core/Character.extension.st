Extension { #name : #Character }

{ #category : #'*petitparser' }
Character >> asLiteral [
	^ PPCharacterLiteral on: self
]
