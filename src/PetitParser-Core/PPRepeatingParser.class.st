"
A parser that eagerly parses min to max instances of my delegate. The default instance parses eagerly an infinite number of elements, as min is set to 0 and max to infinity (SmallInteger maxVal).
"
Class {
	#name : #PPRepeatingParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'min',
		'max'
	],
	#category : #'PetitParser-Parsers'
}

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser [
	^ (super on: aParser) setMin: 0 max: SmallInteger maxVal
]

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser max: aMaxInteger [
	^ (self on: aParser) setMin: 0 max: aMaxInteger
]

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser min: aMinInteger [
	^ (self on: aParser) setMin: aMinInteger max: SmallInteger maxVal 
]

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser min: aMinInteger max: aMaxInteger [
	^ (self on: aParser) setMin: aMinInteger max: aMaxInteger
]

{ #category : #accessing }
PPRepeatingParser >> max [
	"Answer the maximum number of repetitions."

	^ max
]

{ #category : #accessing }
PPRepeatingParser >> min [
	"Answer the minimum number of repetitions."
	
	^ min
]

{ #category : #parsing }
PPRepeatingParser >> parseOn: aStream [
	| start element elements |
	start := aStream position.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := super parseOn: aStream) isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements addLast: element ].
	[ elements size < max ] whileTrue: [
	 	(element := super parseOn: aStream) isPetitFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ].
	^ elements asArray
]

{ #category : #printing }
PPRepeatingParser >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ['; print: min; nextPutAll: ', '; nextPutAll: (max = SmallInteger maxVal
		ifTrue: [ '*' ] ifFalse: [ max asString ]); nextPut: $]
]

{ #category : #initialization }
PPRepeatingParser >> setMin: aMinInteger max: aMaxInteger [
	min := aMinInteger.
	max := aMaxInteger
]
