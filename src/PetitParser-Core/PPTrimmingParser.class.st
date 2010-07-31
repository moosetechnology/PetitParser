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
PPTrimmingParser class >> on: aParser [
	^ self on: aParser trimmer: #space asParser
]

{ #category : #'instance creation' }
PPTrimmingParser class >> on: aParser trimmer: aTrimParser [
	^ self new
		setParser: aParser;
		setTrimmer: aTrimParser;
		yourself
]

{ #category : #parsing }
PPTrimmingParser >> parseOn: aStream [
	| position element |
	position := aStream position.
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	element := super parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: position.
		^ element ].
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	^ element
]

{ #category : #initialization }
PPTrimmingParser >> setTrimmer: aParser [
	trimmer := aParser
]

{ #category : #operations }
PPTrimmingParser >> trim [
	"There is no point in trimming more than once."

	^ self
]
