Extension { #name : #String }

{ #category : #'*petitparser-core-converting' }
String >> asParser [
	^ PPLiteralSequenceParser on: self
]
