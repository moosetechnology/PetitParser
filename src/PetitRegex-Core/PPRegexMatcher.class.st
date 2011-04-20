Class {
	#name : #PPRegexMatcher,
	#superclass : #PPDelegateParser,
	#category : #'PetitRegex-Core'
}

{ #category : #'instance creation' }
PPRegexMatcher class >> for: aParser [
	^ self on: aParser
]

{ #category : #'instance creation' }
PPRegexMatcher class >> for: aParser ignoringCase: aBoolean [ 
	^ self on: aParser
]

{ #category : #'instance creation' }
PPRegexMatcher class >> forString: aString [
	^ self for: (PPRegexParser parse: aString)
]

{ #category : #'instance creation' }
PPRegexMatcher class >> forString: aString ignoreCase: aBoolean [
	^ self for: (PPRegexParser parse: aString) ignoringCase: aBoolean
]

{ #category : #execution }
PPRegexMatcher >> matches: anObject [
	^ parser end matches: anObject
]

{ #category : #execution }
PPRegexMatcher >> matchesIn: anObject collect: aBlock [
	^ (self matchesIn: anObject) collect: aBlock
]

{ #category : #execution }
PPRegexMatcher >> matchesIn: anObject do: aBlock [
	(parser flatten ==> aBlock / #any asParser) star parse: anObject
]

{ #category : #execution }
PPRegexMatcher >> matchesOnStream: aStream [
	^ self matchesIn: aStream
]

{ #category : #execution }
PPRegexMatcher >> matchesOnStream: aStream collect: aBlock [
	^ self matchesIn: aStream collect: aBlock
]

{ #category : #execution }
PPRegexMatcher >> matchesOnStream: aStream do: aBlock [
	^ self matchesIn: aStream do: aBlock
]

{ #category : #execution }
PPRegexMatcher >> matchesStream: aStream [
	^ self matches: aStream
]

{ #category : #execution }
PPRegexMatcher >> matchingRangesIn: anObject do: aBlock [
	(([ :stream | stream position + 1 ] asParser , self , [ :stream | stream position ] asParser ==> [ :nodes | aBlock value: (nodes first to: nodes last) ]) / #any asParser) star parse: anObject
]

{ #category : #execution }
PPRegexMatcher >> search: aString [
	^ self searchOn: aString asPetitStream
]

{ #category : #execution }
PPRegexMatcher >> searchOn: aStream [
	| position result |
	position := aStream position.
	[ aStream atEnd ] whileFalse: [
		(self parseOn: aStream) isPetitFailure
			ifFalse: [ ^ true ].
		aStream position: (position := position + 1) ].
	^ false
]
