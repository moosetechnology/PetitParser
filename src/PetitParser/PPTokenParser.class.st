"
A parser that answers a token of the range my delegate parses.

Instance Variables:
	tokenClass	<PPToken class>	The token sub-class to be used.
"
Class {
	#name : #PPTokenParser,
	#superclass : #PPFlattenParser,
	#instVars : [
		'tokenClass'
	],
	#category : #'PetitParser-Parsers'
}

{ #category : #private }
PPTokenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ self tokenClass on: aCollection start: aStartInteger stop: aStopInteger
]

{ #category : #private }
PPTokenParser >> defaultTokenClass [
	^ PPToken
]

{ #category : #initialization }
PPTokenParser >> initialize [
	tokenClass := self defaultTokenClass
	
]

{ #category : #accessing }
PPTokenParser >> tokenClass [
	^ tokenClass
]

{ #category : #accessing }
PPTokenParser >> tokenClass: aTokenClass [
	tokenClass := aTokenClass
]
