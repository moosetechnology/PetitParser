"
A PPInfoParser is a containing parser providing the evaluation content and the stream content positions.

To use this, only send ""info"" to any PPParser:
'My Parser' asParser info

Instance Variables


"
Class {
	#name : #PPInfoParser,
	#superclass : #PPDelegateParser,
	#category : #PetitPreprocessor
}

{ #category : #'as yet unclassified' }
PPInfoParser >> create: element start: startInteger stop: stopInteger [
	^ PPInfo on: element start: startInteger stop: stopInteger
]

{ #category : #'as yet unclassified' }
PPInfoParser >> parseOn: aPPContext [
	| start element absoluteStart |
	start := aPPContext stream position.
	absoluteStart := aPPContext stream absolutePosition.
	element := parser parseOn: aPPContext.
	element isPetitFailure ifTrue: [
		aPPContext stream position: start.
		^ element ].
	^ self create: element start: (absoluteStart + 1) stop: (aPPContext stream absolutePosition)
]
