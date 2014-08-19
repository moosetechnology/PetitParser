"
The not-predicate, a parser that succeeds whenever its delegate does not, but consumes no input [Parr 1994, 1995].
"
Class {
	#name : #PPNotParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #'pp-context' }
PPNotParser >> parseOn: aPPContext [
	| element position |
	position := aPPContext remember.
	element := parser parseOn: aPPContext.
	aPPContext restore: position.
	^ element isPetitFailure
		ifFalse: [ PPFailure message: '' at: aPPContext position ]
]
