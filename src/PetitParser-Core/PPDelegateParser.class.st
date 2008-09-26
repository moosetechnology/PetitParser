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
PPDelegateParser >> basicParse: aStream [
	^ parser parse: aStream
]

{ #category : #initialization }
PPDelegateParser >> setParser: aParser [
	parser := aParser
]
