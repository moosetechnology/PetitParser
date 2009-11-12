Extension { #name : #String }

{ #category : #'*petitparser-core-converting' }
String >> asParser [
	^ PPLiteralSequenceParser on: self
]

{ #category : #'*petitparser-core' }
String >> flattenedDo: aBlock [
	aBlock value: self
]
