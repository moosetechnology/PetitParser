Extension { #name : #UndefinedObject }

{ #category : #'*petitparser-converting' }
UndefinedObject >> asParser [
	^ PPEpsilonParser new
]
