Extension { #name : #Object }

{ #category : #'*petitparser-core-converting' }
Object >> asParser [
	^ PPPredicateParser expect: self
]

{ #category : #'*petitparser-core-testing' }
Object >> isPetitFailure [
	^ false
]
