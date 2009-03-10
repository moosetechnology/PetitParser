Extension { #name : #BlockContext }

{ #category : #'*petitparser-core-converting' }
BlockContext >> asParser [
	^ PPPluggableParser on: self
]
