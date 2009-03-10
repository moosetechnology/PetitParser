Extension { #name : #BlockClosure }

{ #category : #'*petitparser-core-converting' }
BlockClosure >> asParser [
	^ PPPluggableParser on: self
]
