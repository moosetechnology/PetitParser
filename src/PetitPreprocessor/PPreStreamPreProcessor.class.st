"
A PPreTransformer is a processor able to transform a stream into another stream. It will also create the PPre	Transformation to make possible linking the original stream to the processed stream.

Instance Variables

"
Class {
	#name : #PPreStreamPreProcessor,
	#superclass : #PPDelegateParser,
	#category : #PetitPreprocessor
}

{ #category : #'as yet unclassified' }
PPreStreamPreProcessor >> parseOn: aPPContext [
	|result preProcessedStream startPosition preProcessedContext |
	startPosition := aPPContext stream position.
	preProcessedStream := (self preProcess: aPPContext stream).
	preProcessedContext := PPContext new
									initializeFor: self;
									stream: preProcessedStream;
									yourself.
	"call the contained parser"
	result := super parseOn: preProcessedContext.
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

{ #category : #'as yet unclassified' }
PPreStreamPreProcessor >> preProcess: aStream [
	^ self subclassResponsibility 
]
