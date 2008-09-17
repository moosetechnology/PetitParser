Extension { #name : #BlockClosure }

{ #category : #'*petitparser-converting' }
BlockClosure >> asParser [
	^ PPPluggableParser on: self
]
