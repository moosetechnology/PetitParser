Extension { #name : #BlockContext }

{ #category : #'*petitparser-core-converting' }
BlockContext >> asParser [
	"Answers a parser implemented in the receiving one-argument block."

	^ PPPluggableParser on: self
]
