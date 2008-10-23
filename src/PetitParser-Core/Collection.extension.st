Extension { #name : #Collection }

{ #category : #'*petitparser' }
Collection >> flatten [
	^ (self flattenInto: OrderedCollection new) asArray
]

{ #category : #'*petitparser' }
Collection >> flattenInto: aCollection [
	self do: [ :each |
		each isNil ifFalse: [
			(each isCollection and: [ each isString not ])
				ifTrue: [ each flattenInto: aCollection ]
				ifFalse: [ aCollection add: each ] ] ].
	^ aCollection
]
