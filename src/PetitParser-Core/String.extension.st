Extension { #name : #String }

{ #category : #'*petitparser-core-converting' }
String >> asParser [
	^ PPStringParser on: self
]
