Class {
	#name : #PPStartOfLine,
	#superclass : #PPParser,
	#category : 'PetitParser-Parsers'
}

{ #category : #parsing }
PPStartOfLine >> parseOn: aPPContext [
	(aPPContext isStartOfLine) ifTrue: [ 
		^ #startOfLine
	].
	^ PPFailure message: 'Start of line expected' context: aPPContext at: aPPContext position
]
