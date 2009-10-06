Extension { #name : #Object }

{ #category : #'*petitparser-core-converting' }
Object >> asParser [
	^ PPPredicateParser expect: self
]

{ #category : #'*petitparser-core' }
Object >> flattenedDo: aBlock [
	aBlock value: self
]

{ #category : #'*petitparser-core-testing' }
Object >> isFailure [
	^ false
]
