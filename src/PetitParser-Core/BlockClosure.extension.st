Extension { #name : #BlockClosure }

{ #category : #'*petitparser-core-converting' }
BlockClosure >> asParser [
	"Answers a parser implemented in the receiving one-argument block."

	^ PPPluggableParser on: self
]
