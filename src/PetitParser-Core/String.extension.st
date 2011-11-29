Extension { #name : #String }

{ #category : #'*petitparser-core-converting' }
String >> asParser [
	"Answers a parser that accepts the receiving string."

	^ PPLiteralSequenceParser on: self
]
