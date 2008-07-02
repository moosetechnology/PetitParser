Extension { #name : #BlockClosure }

{ #category : #'*petitparser' }
BlockClosure >> asParser [
	^ PPPluggableParser on: self
]
