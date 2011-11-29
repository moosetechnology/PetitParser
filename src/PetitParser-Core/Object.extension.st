Extension { #name : #Object }

{ #category : #'*petitparser-core-converting' }
Object >> asParser [
	"Answers a parser accepting the receving object."

	^ PPPredicateObjectParser expect: self
]

{ #category : #'*petitparser-core-testing' }
Object >> isPetitFailure [
	^ false
]

{ #category : #'*petitparser-core-testing' }
Object >> isPetitParser [
	^ false
]
