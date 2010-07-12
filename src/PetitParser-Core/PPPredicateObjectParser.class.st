"
A parser that accepts if a given predicate on one element of the input sequence holds.
"
Class {
	#name : #PPPredicateObjectParser,
	#superclass : #PPPredicateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> any [
	^ self
		on: [ :each | true ] message: 'input expected'
		negated: [ :each | false ] message: 'no input expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> anyExceptAnyOf: aCollectionOfChars [
	^ self
		on: [ :each | (aCollectionOfChars includes: each) not ] message: 'any except ' , aCollectionOfChars printString , ' expected'
		negated: [ :each | aCollectionOfChars includes: each ] message: aCollectionOfChars printString ,  ' not expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> anyOf: anArray [
	^ self
		on: [ :each | anArray includes: each ] message: 'any of ' , anArray printString , ' expected'
		negated: [ :each | (anArray includes: each) not ] message: 'none of ' , anArray printString ,  'expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> between: min and: max [
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> blank [
	^ self anyOf: (String with: Character space with: Character tab)
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> char: aCharacter [
	^ self expect: aCharacter
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> control [
	^ self
		on: [ :char | char asInteger < 32 ] message: 'control character expected'
		negated: [ :char | char asInteger >= 32 ] message: 'no control character expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> cr [
	^ self char: Character cr
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> digit [
	^ self 
		on: [ :char | char isDigit ] message: 'digit expected'
		negated: [ :char | char isDigit not ] message: 'no digit expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> expect: anObject [
	^ self 
		on: [ :each | each = anObject ] message: anObject printString , ' expected'
		negated: [ :each | each ~= anObject ] message: anObject printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> hex [
	^ self 
		on: [ :char | 
			(char between: $0 and: $9) 
				or: [ (char between: $a and: $f) 
				or: [ (char between: $A and: $F) ] ] ] 
		message: 'hex digit expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> letter [
	^ self 
		on: [ :char | char isLetter ] message: 'letter expected'
		negated: [ :char | char isLetter not ] message: 'no letter expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> lf [
	^ self char: Character lf
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> lowercase [
	^ self
		on: [ :char | char isLowercase ] message: 'lowercase letter expected'
		negated: [ :char | char isLowercase not ] message: 'no lowercase letter expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> newline [
	^ self anyOf: (String with: Character cr with: Character lf)
]

{ #category : #'instance creation' }
PPPredicateObjectParser class >> on: aBlock message: aString [
	^ self on: aBlock message: aString negated: [ :each | (aBlock value: each) not ] message: 'no ' , aString
]

{ #category : #'instance creation' }
PPPredicateObjectParser class >> on: aBlock message: aString negated: aNegatedBlock message: aNegatedString [
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> punctuation [
	^ self anyOf: '.,"''?!;:#$%&()*+-/<>=@[]\^_{}|~'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> space [
	^ self 
		on: [ :char | char isSeparator ] message: 'separator expected'
		negated: [ :char | char isSeparator not ] message: 'no separator expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> tab [
	^ self char: Character tab
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> uppercase [
	^ self 
		on: [ :char | char isUppercase ] message: 'uppercase letter expected'
		negated: [ :char | char isUppercase not ] message: 'no uppercase letter expected'
		
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> word [
	^ self 
		on: [ :each | each isAlphaNumeric ] message: 'letter or digit expected'
		negated: [ :each | each isAlphaNumeric not ] message: 'no letter or digit expected'
]

{ #category : #initialization }
PPPredicateObjectParser >> initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString [
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString
]

{ #category : #operators }
PPPredicateObjectParser >> negate [
	"Answer a parser that is the negation of the receiving predicate parser."
	
	^ self class 
		on: negated message: negatedMessage 
		negated: predicate message: predicateMessage
]

{ #category : #parsing }
PPPredicateObjectParser >> parseOn: aStream [
	^ (aStream atEnd not and: [ predicate value: aStream peek ])
		ifFalse: [ PPFailure message: predicateMessage at: aStream position ]
		ifTrue: [ aStream next ]
]
