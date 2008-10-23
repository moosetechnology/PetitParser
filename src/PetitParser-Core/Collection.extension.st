Extension { #name : #Collection }

{ #category : #'*petitparser' }
Collection >> flatten [
	^ Array streamContents: [ :stream |
		self flattenedDo: [ :each |
			stream nextPut: each ] ]
]

{ #category : #'*petitparser' }
Collection >> flattenedDo: aBlock [
	self do: [ :each |
		(each isCollection and: [ each isString not ])
			ifTrue: [ each flattenedDo: aBlock ]
			ifFalse: [ aBlock value: each ] ]
]
