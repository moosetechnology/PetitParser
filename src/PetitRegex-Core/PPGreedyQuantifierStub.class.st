Class {
	#name : #PPGreedyQuantifierStub,
	#superclass : #PPRepeatingParser,
	#category : #'PetitRegex-Core'
}

{ #category : #protected }
PPGreedyQuantifierStub >> resolve: aParser [
	^ (min = 0 and: [ max = SmallInteger maxVal ])
		ifTrue: [ parser starGreedy: aParser ]
		ifFalse: [
			(min = 1 and: [ max = SmallInteger maxVal ])
				ifTrue: [ parser plusGreedy: aParser ]
				ifFalse: [ 
					(min = 0 and: [ max = 1 ])
						ifTrue: [ parser / aParser and ]
						ifFalse: [ self error: 'Invalid quantifier range' ] ] ]
]
