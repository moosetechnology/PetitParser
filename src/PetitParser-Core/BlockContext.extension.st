Extension { #name : #BlockContext }

{ #category : #'*petitparser' }
BlockContext >> asParser [
	^ PPPluggableParser on: self
]
