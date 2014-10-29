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

{ #category : #parsing }
PPTrimmingParser >> parseOn: aPPContext [
	| memento element |
	memento := aPPContext remember.
	[ (trimmer parseOn: aPPContext) isPetitFailure ]
		whileFalse.
	element := parser parseOn: aPPContext.
	element isPetitFailure ifTrue: [
		aPPContext restore: memento.
		^ element ].
	[ (trimmer parseOn: aPPContext) isPetitFailure ]
		whileFalse.
	^ element
]

{ #category : #initialization }
PPTrimmingParser >> setTrimmer: aParser [
	trimmer := aParser
]
