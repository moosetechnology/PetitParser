Class {
	#name : #PPBrowserWrapper,
	#superclass : #PPDelegateParser,
	#instVars : [
		'before',
		'after'
	],
	#category : #'PetitGui-Core'
}

{ #category : #accessing }
PPBrowserWrapper >> after [
	^ after
]

{ #category : #accessing }
PPBrowserWrapper >> after: anObject [
	after := anObject
]

{ #category : #accessing }
PPBrowserWrapper >> before [
	^ before
]

{ #category : #accessing }
PPBrowserWrapper >> before: anObject [
	before := anObject
]

{ #category : #parsing }
PPBrowserWrapper >> parseOn: aStream [
	| seed result |
	seed := before value: aStream.
	result := super parseOn: aStream.
	after value: aStream value: seed.
	^ result
]
