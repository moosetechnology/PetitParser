Class {
	#name : #PPSmalltalkToken,
	#superclass : #PPToken,
	#instVars : [
		'comments'
	],
	#category : #'PetitSmalltalk-Core'
}

{ #category : #'instance creation' }
PPSmalltalkToken class >> on: aSequenzeableCollection start: aStartInteger stop: aStopInteger comments: anArray [
	^ (self on: aSequenzeableCollection start: aStartInteger stop: aStopInteger) comments: anArray
]

{ #category : #accessing }
PPSmalltalkToken >> comments [
	^ comments
]

{ #category : #accessing }
PPSmalltalkToken >> comments: anArray [
	comments := anArray
]

{ #category : #compatiblity }
PPSmalltalkToken >> length [
	^ self size
]
