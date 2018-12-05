"
A PPreRegexStreamPreProcessor is a preProcessor based on regular expression.

Instance Variables
	regex:		<Object>
	replacement:		<Object>

regex
	- xxxxx

replacement
	- xxxxx

"
Class {
	#name : #PPreRegexStreamPreProcessor,
	#superclass : #PPreStreamPreProcessor,
	#instVars : [
		'regex',
		'replacement'
	],
	#category : #PetitPreprocessor
}

{ #category : #'as yet unclassified' }
PPreRegexStreamPreProcessor >> intervalsToReplace: aStream [ 
	| position ranges |
	position := aStream position.
	ranges :=( regex matchingRangesIn: aStream) .

	aStream position: position.
	^ ranges
]

{ #category : #'as yet unclassified' }
PPreRegexStreamPreProcessor >> preProcess: aStream [
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

{ #category : #accessing }
PPreRegexStreamPreProcessor >> regex [
	^ regex
]

{ #category : #accessing }
PPreRegexStreamPreProcessor >> regex: anObject [
	regex := anObject
]

{ #category : #accessing }
PPreRegexStreamPreProcessor >> replacement [
	^ replacement
]

{ #category : #accessing }
PPreRegexStreamPreProcessor >> replacement: anObject [
	replacement := anObject
]

{ #category : #'as yet unclassified' }
PPreRegexStreamPreProcessor >> write: aStream into: anotherStream forRange: aRange [
	| aStreamStart anotherStreamStart |
	
	[(aStream position + 1) < (aRange first)] whileTrue: [anotherStream nextPut: aStream next]. 
	
	aStreamStart:= aStream position.
	anotherStreamStart:= anotherStream position.
	
	anotherStream nextPutAll: replacement.
	aStream skip: aRange size.
	
	^ PPreIntervalTransformation from: (Interval from: aStreamStart to: aStream position) to: (Interval from: anotherStreamStart to: anotherStream position)
]
