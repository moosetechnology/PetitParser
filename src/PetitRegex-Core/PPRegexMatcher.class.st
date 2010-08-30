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

{ #category : #'as yet unclassified' }
PPRegexMatcher >> search: aString [
	^ self searchOn: aString asPetitStream
]

{ #category : #'as yet unclassified' }
PPRegexMatcher >> searchOn: aStream [
	| position result |
	position := aStream position.
	[ aStream atEnd ] whileFalse: [
		(self parseOn: aStream) isPetitFailure
			ifFalse: [ ^ true ].
		aStream position: (position := position + 1) ].
	^ false
]
