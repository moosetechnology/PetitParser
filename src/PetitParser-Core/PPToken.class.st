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
PPToken class >> on: aSequenzeableCollection [
	^ self on: aSequenzeableCollection start: 1 stop: aSequenzeableCollection size
]

{ #category : #'instance creation' }
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

{ #category : #compatibility }
PPToken >> isPatternVariable [
	^ self size > 0 and: [ (self collection at: self start) = $` ]
]

{ #category : #compatibility }
PPToken >> isRBToken [
	^ false
]

{ #category : #compatibility }
PPToken >> length [
	^ self size
]

{ #category : #compatibility }
PPToken >> next [
	^ nil
]

{ #category : #compatibility }
PPToken >> previous [
	^ nil
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

{ #category : #compatibility }
PPToken >> startPosition [
	^ self start
]

{ #category : #accessing }
PPToken >> stop [
	^ stop
]

{ #category : #compatibility }
PPToken >> stopPosition [
	^ self stop
]

{ #category : #accessing }
PPToken >> value [
	^ collection copyFrom: start to: stop
]
