Class {
	#name : #PPToken,
	#superclass : #Object,
	#instVars : [
		'collection',
		'from',
		'to'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPToken class >> on: aSequenzeableCollection from: aFromInteger to: aToInteger [ 
	^ self basicNew 
		initializeOn: aSequenzeableCollection
		from: aFromInteger
		to: aToInteger
]

{ #category : #accessing }
PPToken >> collection [
	^ collection
]

{ #category : #accessing }
PPToken >> from [
	^ from
]

{ #category : #'accessing-compatibility' }
PPToken >> id [
	^ 0
]

{ #category : #initialization }
PPToken >> initializeOn: aSequenzeableCollection from: aFromInteger to: aToInteger [ 
	collection := aSequenzeableCollection.
	from := aFromInteger.
	to := aToInteger
]

{ #category : #'accessing-compatibility' }
PPToken >> length [
	^ to - from + 1
]

{ #category : #'accessing-compatibility' }
PPToken >> startPosition [
	^ from
]

{ #category : #'accessing-compatibility' }
PPToken >> stopPosition [
	^ to
]

{ #category : #accessing }
PPToken >> to [
	^ to
]

{ #category : #accessing }
PPToken >> value [
	^ collection copyFrom: from to: to
]
