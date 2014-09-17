"
I return failure, if the delegate parser did not consumed any input.
"
Class {
	#name : #PPNonEmptyParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitIslands-Parsers'
}

{ #category : #parsing }
PPNonEmptyParser >> parseOn: aPPContext [
	| position result |
	position := aPPContext position.
	result := parser parseOn: aPPContext.
	

	(((position == aPPContext position) and: [ aPPContext atEnd not ]) and: [ result isPetitFailure not ]) ifTrue: [ 
		^ PPFailure message: 'Epsilon parse not allowed' context: aPPContext at: position
	].
	^ result
]
