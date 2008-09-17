Extension { #name : #Set }

{ #category : #'*petitparser-converting' }
Set >> asParser [
	^ PPChoiceParser withAll: (self collect: [ :each | each asParser ])
]
