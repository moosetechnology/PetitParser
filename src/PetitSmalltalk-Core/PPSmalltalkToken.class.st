Class {
	#name : #PPSmalltalkToken,
	#superclass : #PPToken,
	#instVars : [
		'comments'
	],
	#category : #'PetitSmalltalk-Core'
}

{ #category : #accessing }
PPSmalltalkToken >> comments [
	^ comments
]

{ #category : #accessing }
PPSmalltalkToken >> comments: anArray [
	comments := anArray
]
