Extension { #name : #String }

{ #category : #'*petitparser-core-converting' }
String >> asParser [
	^ PPStringParser on: self
]

{ #category : #'*petitparser-core' }
String >> flattenedDo: aBlock [
	aBlock value: self
]
