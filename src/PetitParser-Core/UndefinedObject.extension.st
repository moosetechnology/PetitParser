Extension { #name : #UndefinedObject }

{ #category : #'*petitparser-converting' }
UndefinedObject >> asParser [
	"Answers a parser that succeeds and does not consume anything."
	
	^ PPEpsilonParser new
]
