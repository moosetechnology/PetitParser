"
A parser that performs an action on the delegate.
"
Class {
	#name : #PPActionParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'block'
	],
	#category : #'PetitParser-Core'
}

{ #category : #accessing }
PPActionParser >> block: aBlock [
	block := aBlock
]

{ #category : #parsing }
PPActionParser >> parse: aStream [
	| element |
	element := super parse: aStream.
	^ element isFailure
		ifTrue: [ element ]
		ifFalse: [ block value: element ]
]
