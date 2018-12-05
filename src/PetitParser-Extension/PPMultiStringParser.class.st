"
A PPMultiStringParser is a tool able to create a really effective parser on a huge  collection of Strings. This parser will match any string in this collection, and the longest one if two are matchable (( PPMultiStringParser on: #('tin' 'tintin')) parse: 'tintin' will match 'tintin' and not just 'tin')

Instance Variables
	possibilities:		<Object>

possibilities
	- xxxxx

"
Class {
	#name : #PPMultiStringParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'possibilities'
	],
	#category : #'PetitParser-Extension'
}

{ #category : #'as yet unclassified' }
PPMultiStringParser class >> on: aStringCollection [
	^ self new possibilities: aStringCollection; yourself
]

{ #category : #'as yet unclassified' }
PPMultiStringParser >> createParsersFrom: aStringCollection [
	| dictionary p createdParser |
	aStringCollection size = 1 ifTrue: [^ aStringCollection first asParser].

	dictionary := ((aStringCollection select: [:s | s isEmpty not]) groupedBy: [:s | s first]).
	dictionary keys do: [:k | p := k asParser, (self createParsersFrom: ((dictionary at: k) collect: [:s | s allButFirst ])). createdParser ifNil: [createdParser := p] ifNotNil: [createdParser := createdParser / p]].

	(aStringCollection select: [:s | s isEmpty]) ifNotEmpty: [ p:= PPEpsilonParser new. createdParser ifNil: [createdParser := p] ifNotNil: [createdParser := createdParser / p]].
	
	^ createdParser
]

{ #category : #'as yet unclassified' }
PPMultiStringParser >> possibilities: aStringCollection [
	possibilities := aStringCollection.
	self setParser: (self createParsersFrom: (aStringCollection sorted: [:a :b | b >= a])) flatten
]
