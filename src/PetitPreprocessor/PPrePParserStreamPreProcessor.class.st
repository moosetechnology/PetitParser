Class {
	#name : #PPrePParserStreamPreProcessor,
	#superclass : #PPreStreamPreProcessor,
	#instVars : [
		'matchingParser'
	],
	#category : 'PetitPreprocessor-Core'
}

{ #category : #accessing }
PPrePParserStreamPreProcessor >> intervalsToReplace: aStream [ 
	| position ranges lastPosition keep |
	position := aStream position.
	lastPosition := -1.
	ranges := (matchingParser matchingRangesIn: aStream) select: [:i | keep := (lastPosition < i first). lastPosition := i last. keep ].
	aStream position: position.
	^ ranges
]

{ #category : #accessing }
PPrePParserStreamPreProcessor >> matchingParser [
	^ matchingParser 
]

{ #category : #accessing }
PPrePParserStreamPreProcessor >> matchingParser: aPParser [
	matchingParser := aPParser 
]

{ #category : #parsing }
PPrePParserStreamPreProcessor >> preProcess: aStream [
	"Return a new PPRelativePositionStream which stores all transformations"
	| result transformation |
	result := WriteStream with: ''.
	transformation := PPreIntervalTransformations startingAt: aStream position.
	(self intervalsToReplace: aStream) do: 
		[:aRange | transformation addTransformation: (self write: aStream into: result forRange: aRange).
			 ].
	aStream do: [:c | result nextPut: c].
	^ PPRelativePositionStream on: (result contents) relativeTo: aStream with: transformation
]

{ #category : #writing }
PPrePParserStreamPreProcessor >> write: aStream into: anotherStream forRange: aRange [
	| aStreamStart anotherStreamStart |
	
	[(aStream position + 1) < (aRange first)] whileTrue: [anotherStream nextPut: aStream next]. 
	
	aStreamStart:= aStream position.
	anotherStreamStart:= anotherStream position.
	anotherStream nextPutAll: (matchingParser parse: (aStream collection copyFrom: aRange first to: aRange last)).
	aStream skip: aRange size.

	^ PPreIntervalTransformation from: (Interval from: aStreamStart to: aStream position) to: (Interval from: anotherStreamStart to: anotherStream position)
]
