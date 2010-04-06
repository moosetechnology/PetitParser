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
PPToken class >> on: aSequenzeableCollection [
	^ self on: aSequenzeableCollection start: 1 stop: aSequenzeableCollection size
]

{ #category : #'instance creation' }
PPToken class >> on: aSequenzeableCollection start: aStartInteger stop: aStopInteger [
	^ self basicNew 
		initializeOn: aSequenzeableCollection
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
PPToken >> initializeOn: aSequenzeableCollection start: aStartInteger stop: aStopInteger [
	collection := aSequenzeableCollection.
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
