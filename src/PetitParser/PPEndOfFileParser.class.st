"
A PPEndOfFileParser is parser that will will return true if the stream position is at the end, returns failure otherwise.

The diffirenece between PPEndOfFIleParser and PPEndOfInputParser is:
 - PPEndOfFileParser can be created using #eof asParser
 - PPEndOfInputParser can be created by using parser end
 - PPEndOfFileParser does not delegate to any other parser
 - PPEndOfInputParser parsers its delegate and then decides if the input is at the end.

The PPEndOfFileParser can be used to accept some input only if it is at the end of the input, e.g:

   ('a' asParser, #eof asParser) parse: 'a'
   ('a' asParser, #eof asParser) parse: 'aa'

"
Class {
	#name : #PPEndOfFileParser,
	#superclass : #PPParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #'as yet unclassified' }
PPEndOfFileParser >> acceptsEpsilon [
	^ true
]

{ #category : #'as yet unclassified' }
PPEndOfFileParser >> exampleOn: aStream [ 
	aStream nextPutAll: #'end-of-input'
]

{ #category : #'as yet unclassified' }
PPEndOfFileParser >> isNullable [ 
	^ true
]

{ #category : #'as yet unclassified' }
PPEndOfFileParser >> nonEmpty [
	"I know I am empty, but it does not count in my case, I represent virtual non-existent character"
	^ self
]

{ #category : #'as yet unclassified' }
PPEndOfFileParser >> parseOn: aPPContext [
	(aPPContext atEnd) ifFalse:
	[
		^ PPFailure message: 'end of input expected' context: aPPContext.
	].
	^ #'end-of-input'
]
