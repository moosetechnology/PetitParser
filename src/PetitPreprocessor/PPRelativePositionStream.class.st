"
A PPRelativePositionStream is a specialized stream to get the relative position according to another stream.

Instance Variables

"
Class {
	#name : #PPRelativePositionStream,
	#superclass : #PPStream,
	#instVars : [
		'relativeStream',
		'transformation'
	],
	#category : 'PetitPreprocessor-Core'
}

{ #category : #'instance creation' }
PPRelativePositionStream class >> on: aStream relativeTo: aRelativeStream with: aTransformation [
	^ (super on: aStream) relativeStream: aRelativeStream; transformation: aTransformation; yourself
]

{ #category : #accessing }
PPRelativePositionStream >> absolutePosition: aPosition [
	"return the absolute position of this stream (related to the original stream)"
	^  relativeStream absolutePosition: (self relativePosition: aPosition ) 
]

{ #category : #position }
PPRelativePositionStream >> relativePosition: aPosition [
	"Return the relative position of this stream to its parent stream"
	^  (transformation relativePosition: aPosition) 
]

{ #category : #accessing }
PPRelativePositionStream >> relativeStream [
	^ relativeStream
]

{ #category : #accessing }
PPRelativePositionStream >> relativeStream: anObject [
	relativeStream := anObject
]

{ #category : #accessing }
PPRelativePositionStream >> transformation [
	^ transformation
]

{ #category : #accessing }
PPRelativePositionStream >> transformation: anObject [
	transformation := anObject
]
