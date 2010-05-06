Class {
	#name : #PPLazyQuantifierStub,
	#superclass : #PPRepeatingParser,
	#category : #'PetitRegex-Core'
}

{ #category : #protected }
PPLazyQuantifierStub >> resolve: aParser [
	^ (min = 0 and: [ max = SmallInteger maxVal ])
		ifTrue: [ parser starLazy: aParser ]
		ifFalse: [ 
			(min = 1 and: [ max = SmallInteger maxVal ])
				ifTrue: [ parser plusLazy: aParser ]
				ifFalse: [ 
					(min = 0 and: [ max = 1 ])
						ifTrue: [ aParser and / parser ]
						ifFalse: [ self error: 'Invalid quantifier range' ] ] ]
]
