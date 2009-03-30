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

{ #category : #parsing }
PPActionParser >> basicParse: aStream [
	| element |
	^ (element := super basicParse: aStream) isFailure
		ifFalse: [ block value: element ]
		ifTrue: [ element ]
]

{ #category : #accessing }
PPActionParser >> block: aBlock [
	block := aBlock fixTemps
]
