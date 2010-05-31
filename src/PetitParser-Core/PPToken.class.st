"
PPToken represents a parsed part of the input stream. Contrary to a simple String it rembers where it came from, the original collection and its start and stop position.

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
	#category : #'PetitParser-Core'
}

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
	^ collection
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

{ #category : #printing }
PPToken >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(; nextPutAll: self value; nextPut: $)
]

{ #category : #accessing }
PPToken >> size [
	^ self stop - self start + 1
]

{ #category : #accessing }
PPToken >> start [
	^ start
]

{ #category : #accessing }
PPToken >> stop [
	^ stop
]

{ #category : #accessing }
PPToken >> value [
	^ collection copyFrom: start to: stop
]
