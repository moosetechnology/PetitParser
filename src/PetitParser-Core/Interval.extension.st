Extension { #name : #Interval }

{ #category : #'*petitparser' }
Interval >> asParser [
	^ PPPredicateParser between: start and: stop
]
