"
PPToken represents a parsed part of the input stream. Contrary to a simple String it remembers where it came from, the original collection and its start and stop position.

Instance Variables:
	collection	<SequenceableCollection>	The collection this token comes from.
	start	<Integer>	The start position in the collection.
	stop	<Integer>	The stop position in the collection.
"
Class {
	#name : #PPToken,
	#superclass : #Object,
	#instVars : [
		'collection',
		'start',
		'stop'
	],
	#classVars : [
		'NewLineParser'
	],
	#category : #'PetitParser-Core'
}

{ #category : #initialization }
PPToken class >> initialize [
	"Platform independent newline sequence. LF: Unix, CR+LF: Windows, and CR: Apple."

	NewLineParser := (Character lf asParser) / (Character cr asParser , Character lf asParser optional)
]

{ #category : #'instance creation' }
PPToken class >> new [
	self error: 'Token can only be created using a dedicated constructor.'
]

{ #category : #'instance creation' }
PPToken class >> on: aSequenceableCollection [
	^ self on: aSequenceableCollection start: 1 stop: aSequenceableCollection size
]

{ #category : #'instance creation' }
PPToken class >> on: aSequenceableCollection start: aStartInteger stop: aStopInteger [
	^ self basicNew 
		initializeOn: aSequenceableCollection
		start: aStartInteger stop: aStopInteger
]

{ #category : #comparing }
PPToken >> = anObject [
	^ self class = anObject class and: [ self value = anObject value ]
]

{ #category : #accessing }
PPToken >> collection [
	"Answer the underlying collection of this token."

	^ collection
]

{ #category : #querying }
PPToken >> column [
	"Answer the column number of this token in the underlying collection."
	
	| position |
	position := 0.
	(NewLineParser , [ :stream |
		start <= stream position
			ifTrue: [ ^ start - position ].
		position := stream position ] asParser
		/ #any asParser) star
			parse: collection.
	 ^ start - position
]

{ #category : #copying }
PPToken >> copyFrom: aStartInteger to: aStopInteger [
	^ self class on: collection start: start + aStartInteger - 1 stop: stop + aStopInteger - 3
]

{ #category : #comparing }
PPToken >> hash [
	^ self value hash
]

{ #category : #initialization }
PPToken >> initializeOn: aSequenceableCollection start: aStartInteger stop: aStopInteger [
	collection := aSequenceableCollection.
	start := aStartInteger.
	stop := aStopInteger
]

{ #category : #querying }
PPToken >> line [
	"Answer the line number of this token in the underlying collection."
	
	| line |
	line := 1.
	(NewLineParser , [ :stream |
		start <= stream position
			ifTrue: [ ^ line ].
		line := line + 1 ] asParser
		/ #any asParser) star
			parse: collection.
	^ line
]

{ #category : #printing }
PPToken >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(; nextPutAll: self value; nextPut: $)
]

{ #category : #accessing }
PPToken >> size [
	"Answer the size of this token."

	^ stop - start + 1
]

{ #category : #accessing }
PPToken >> start [
	"Answer the start position of this token in the underlying collection."

	^ start
]

{ #category : #accessing }
PPToken >> stop [
	"Answer the stop position of this token in the underlying collection."
	
	^ stop
]

{ #category : #accessing }
PPToken >> value [
	"Answer the contents of this token."

	^ collection copyFrom: start to: stop
]
