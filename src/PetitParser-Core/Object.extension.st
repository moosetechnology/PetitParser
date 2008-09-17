Extension { #name : #Object }

{ #category : #'*petitparser-converting' }
Object >> asParser [
	^ PPPredicateParser expect: self
]

{ #category : #'*petitparser-testing' }
Object >> isFailure [
	^ false
]
