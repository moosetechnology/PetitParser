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

{ #category : #parsing }
PPActionParser >> basicParse: aStream [
	| element |
	^ (element := super basicParse: aStream) isFailure
		ifFalse: [ block value: element ]
		ifTrue: [ element ]
]

{ #category : #accessing }
PPActionParser >> block: aBlock [
	block := aBlock
]
