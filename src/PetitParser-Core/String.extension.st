Extension { #name : #String }

{ #category : #'*petitparser-converting' }
String >> asParser [
	^ PPStringParser on: self
]
