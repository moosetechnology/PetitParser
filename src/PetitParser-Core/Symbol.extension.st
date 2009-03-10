Extension { #name : #Symbol }

{ #category : #'*petitparser-core-converting' }
Symbol >> asParser [
	^ PPPredicateParser perform: self
]

{ #category : #'*petitparser' }
Symbol >> fixTemps [
	^ self
]
