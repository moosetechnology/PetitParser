Extension { #name : #String }

{ #category : #'*petitparser' }
String >> asLiteral [
	^ PPStringLiteral on: self
]
