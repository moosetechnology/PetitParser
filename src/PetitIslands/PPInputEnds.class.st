Class {
	#name : #PPInputEnds,
	#superclass : #PPParser,
	#category : #'PetitIslands-Parsers'
}

{ #category : #'as yet unclassified' }
PPInputEnds >> acceptsEpsilon [
	^ true
]

{ #category : #'as yet unclassified' }
PPInputEnds >> exampleOn: aStream [ 
	aStream nextPutAll: '#End Of Input#'
]

{ #category : #'as yet unclassified' }
PPInputEnds >> isNullable [ 
	^ true
]

{ #category : #'as yet unclassified' }
PPInputEnds >> nonEmpty [
	"I know I am empty, but it does not count in my case, I represent virtual non-existent character"
	^ self
]

{ #category : #'as yet unclassified' }
PPInputEnds >> parseOn: aPPContext [
	(aPPContext atEnd) ifFalse:
	[
		^ PPFailure message: 'end of input expected' context: aPPContext.
	].
	^ #inputEnds
]
