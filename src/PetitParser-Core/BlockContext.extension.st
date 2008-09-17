Extension { #name : #BlockContext }

{ #category : #'*petitparser-converting' }
BlockContext >> asParser [
	^ PPPluggableParser on: self
]
