"
A PPreTransformer is a processor able to transform a stream into another stream. It will also create the PPre	Transformation to make possible linking the original stream to the processed stream.

Instance Variables

"
Class {
	#name : #PPreStreamPreProcessor,
	#superclass : #PPDelegateParser,
	#category : #'PetitPreprocessor-Core'
}

{ #category : #parsing }
PPreStreamPreProcessor >> parseOn: aPPContext [
	|result preProcessedStream startPosition |
	startPosition := aPPContext position.
	preProcessedStream := (self preProcess: aPPContext stream).
	"call the contained parser"
	result := super parseOn: (PPContext new
										initializeFor: self;
										stream: preProcessedStream;
										yourself).
	result isPetitFailure 
		ifTrue: 
			"restore stream position"
			[aPPContext stream position: startPosition.
			result position: (preProcessedStream relativePosition: result position)] 
		ifFalse: 
			"place unprocessed stream at the position corresponding to the processed stream after parsing"
			[aPPContext stream position: (preProcessedStream relativePosition)].
	^ result.
]

{ #category : #parsing }
PPreStreamPreProcessor >> preProcess: aStream [
	^ self subclassResponsibility 
]
