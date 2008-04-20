Extension { #name : #Set }

{ #category : #'*petitparser' }
Set >> asParser [
	^ self 
		inject: PPChoiceParser new
		into: [ :result :each | result | each asParser ]
]
