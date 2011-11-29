Extension { #name : #BlockContext }

{ #category : #'*petitparser-core-converting' }
BlockContext >> asParser [
	"Answer a parser implemented in the receiving one-argument block."

	^ PPPluggableParser on: self
]
