"
A parser that accepts if a given predicate holds.

Instance Variables:
	predicate	<BlockClosure>	The block testing for the predicate.
	predicateMessage	<String>	The error message of the predicate.
	negated	<BlockClosure>	The block testing for the negation of the predicate.
	negatedMessage	<String>	The error message of the negated predicate.
"
Class {
	#name : #PPPredicateParser,
	#superclass : #PPParser,
	#instVars : [
		'predicate',
		'predicateMessage',
		'negated',
		'negatedMessage'
	],
	#category : #'PetitParser-Parsers'
}

{ #category : #'factory-objects' }
PPPredicateParser class >> any [
	^ self
		on: [ :each | true ] message: 'input expected'
		negated: [ :each | false ] message: 'no input expected'
]

{ #category : #'factory-objects' }
PPPredicateParser class >> anyOf: anArray [
	^ self
		on: [ :each | anArray includes: each ] message: 'any of ' , anArray printString , ' expected'
		negated: [ :each | (anArray includes: each) not ] message: 'none of ' , anArray printString ,  'expected'
]

{ #category : #'factory-objects' }
PPPredicateParser class >> between: min and: max [
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> blank [
	^ self anyOf: (String with: Character space with: Character tab)
]

{ #category : #'factory-chars' }
PPPredicateParser class >> char: aCharacter [
	^ self expect: aCharacter
]

{ #category : #'factory-chars' }
PPPredicateParser class >> control [
	^ self
		on: [ :char | char asInteger < 32 ] message: 'control character expected'
		negated: [ :char | char asInteger >= 32 ] message: 'no control character expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> cr [
	^ self char: Character cr
]

{ #category : #'factory-chars' }
PPPredicateParser class >> digit [
	^ self 
		on: [ :char | char isDigit ] message: 'digit expected'
		negated: [ :char | char isDigit not ] message: 'no digit expected'
]

{ #category : #'factory-objects' }
PPPredicateParser class >> expect: anObject [
	^ self 
		on: [ :each | each = anObject ] message: anObject printString , ' expected'
		negated: [ :each | each ~= anObject ] message: anObject printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> hex [
	^ self 
		on: [ :char | 
			(char between: $0 and: $9) 
				or: [ (char between: $a and: $f) 
				or: [ (char between: $A and: $F) ] ] ] 
		message: 'hex digit expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> letter [
	^ self 
		on: [ :char | char isLetter ] message: 'letter expected'
		negated: [ :char | char isLetter not ] message: 'no letter expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> lf [
	^ self char: Character lf
]

{ #category : #'factory-chars' }
PPPredicateParser class >> lowercase [
	^ self
		on: [ :char | char isLowercase ] message: 'lowercase letter expected'
		negated: [ :char | char isLowercase not ] message: 'no lowercase letter expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> newline [
	^ self anyOf: (String with: Character cr with: Character lf)
]

{ #category : #'instance creation' }
PPPredicateParser class >> on: aBlock message: aString [
	^ self on: aBlock message: aString negated: [ :each | (aBlock value: each) not ] message: 'no ' , aString
]

{ #category : #'instance creation' }
PPPredicateParser class >> on: aBlock message: aString negated: aNegatedBlock message: aNegatedString [
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
]

{ #category : #'factory-chars' }
PPPredicateParser class >> punctuation [
	^ self anyOf: '.,"''?!;:#$%&()*+-/<>=@[]\^_{}|~'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> space [
	^ self 
		on: [ :char | char isSeparator ] message: 'separator expected'
		negated: [ :char | char isSeparator not ] message: 'no separator expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> tab [
	^ self char: Character tab
]

{ #category : #'factory-chars' }
PPPredicateParser class >> uppercase [
	^ self 
		on: [ :char | char isUppercase ] message: 'uppercase letter expected'
		negated: [ :char | char isUppercase not ] message: 'no uppercase letter expected'
		
]

{ #category : #'factory-chars' }
PPPredicateParser class >> word [
	^ self 
		on: [ :each | each isAlphaNumeric ] message: 'letter or digit expected'
		negated: [ :each | each isAlphaNumeric not ] message: 'no letter or digit expected'
]

{ #category : #accessing }
PPPredicateParser >> block [
	"Answer the predicate block of the receiver."
	
	^ predicate
]

{ #category : #initialization }
PPPredicateParser >> initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString [
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString
]

{ #category : #accessing }
PPPredicateParser >> message [
	"Answer the failure message."
	
	^ predicateMessage
]

{ #category : #operators }
PPPredicateParser >> negate [
	"Answer a parser that is the negation of the receiving predicate parser."
	
	^ self class 
		on: negated message: negatedMessage 
		negated: predicate message: predicateMessage
]

{ #category : #parsing }
PPPredicateParser >> parseOn: aStream [
	^ (aStream atEnd not and: [ predicate value: aStream peek ])
		ifFalse: [ PPFailure message: predicateMessage at: aStream position ]
		ifTrue: [ aStream next ]
]

{ #category : #printing }
PPPredicateParser >> printNameOn: aStream [
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: predicateMessage
]
