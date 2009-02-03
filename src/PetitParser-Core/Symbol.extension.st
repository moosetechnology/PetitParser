Extension { #name : #Symbol }

{ #category : #'*petitparser-converting' }
Symbol >> asParser [
	^ PPPredicateParser perform: self
]

{ #category : #'*petitparser' }
Symbol >> fixTemps [
	^ self
]
