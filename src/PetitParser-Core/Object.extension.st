Extension { #name : #Object }

{ #category : #'*petitparser' }
Object >> asParser [
	^ PPPredicateParser expect: self
]

{ #category : #'*petitparser-testing' }
Object >> isFailure [
	^ false
]
