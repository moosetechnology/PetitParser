"
A parser that delegates to another parser.
"
Class {
	#name : #PPDelegateParser,
	#superclass : #PPParser,
	#instVars : [
		'parser'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPDelegateParser class >> on: aParser [
	^ self new setParser: aParser
]

{ #category : #parsing }
PPDelegateParser >> parse: aStream [ 
	^ parser parse: aStream
]

{ #category : #printing }
PPDelegateParser >> printOn: aStream [ 
	aStream nextPut: $(; print: parser; nextPut: $)
]

{ #category : #initialization }
PPDelegateParser >> setParser: aParser [
	parser := aParser
]
