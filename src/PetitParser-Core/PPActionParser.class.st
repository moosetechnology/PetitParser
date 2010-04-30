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

{ #category : #'instance creation' }
PPActionParser class >> on: aParser block: aBlock [
	^ (self on: aParser) block: aBlock
]

{ #category : #accessing }
PPActionParser >> block [
	"Answer the action block of the receiver."

	^ block
]

{ #category : #accessing }
PPActionParser >> block: aBlock [
	block := aBlock
]

{ #category : #parsing }
PPActionParser >> parseOn: aStream [
	| element |
	^ (element := super parseOn: aStream) isPetitFailure
		ifFalse: [ block value: element ]
		ifTrue: [ element ]
]
