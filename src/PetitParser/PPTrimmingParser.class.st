"
A parser that silently consumes spaces before and after the delegate parser.
"
Class {
	#name : #PPTrimmingParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'trimmer'
	],
	#category : #'PetitParser-Parsers'
}

{ #category : #'instance creation' }
PPTrimmingParser class >> on: aParser trimmer: aTrimParser [
	^ self new
		setParser: aParser;
		setTrimmer: aTrimParser;
		yourself
]

{ #category : #'pp-context' }
PPTrimmingParser >> parseOn: aPPContext [
	| position element |
	position := aPPContext remember.
	[ (trimmer parseOn: aPPContext) isPetitFailure ]
		whileFalse.
	element := parser parseOn: aPPContext.
	element isPetitFailure ifTrue: [
		aPPContext restore: position.
		^ element ].
	[ (trimmer parseOn: aPPContext) isPetitFailure ]
		whileFalse.
	^ element
]

{ #category : #initialization }
PPTrimmingParser >> setTrimmer: aParser [
	trimmer := aParser
]
