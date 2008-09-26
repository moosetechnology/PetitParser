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

{ #category : #'instance-creation' }
PPToken class >> on: aSequenzeableCollection start: aStartInteger stop: aStopInteger [
	^ self basicNew 
		initializeOn: aSequenzeableCollection
		start: aStartInteger stop: aStopInteger
]

{ #category : #accessing }
PPToken >> collection [
	^ collection
]

{ #category : #copying }
PPToken >> copyFrom: aStartInteger to: aStopInteger [
	^ self class on: collection start: start + aStartInteger - 1 stop: stop + aStopInteger - 3
]

{ #category : #initialization }
PPToken >> initializeOn: aSequenzeableCollection start: aStartInteger stop: aStopInteger [
	collection := aSequenzeableCollection.
	start := aStartInteger.
	stop := aStopInteger
]

{ #category : #'accessing-compatibility' }
PPToken >> isPatternVariable [
	^ false
]

{ #category : #'accessing-compatibility' }
PPToken >> isRBToken [
	^ false
]

{ #category : #'accessing-compatibility' }
PPToken >> length [
	^ self size
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

{ #category : #'accessing-compatibility' }
PPToken >> startPosition [
	^ self start
]

{ #category : #accessing }
PPToken >> stop [
	^ stop
]

{ #category : #'accessing-compatibility' }
PPToken >> stopPosition [
	^ self stop
]

{ #category : #accessing }
PPToken >> value [
	^ collection copyFrom: start to: stop
]
