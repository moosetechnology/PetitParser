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
PPPredicateObjectParser class >> anyExceptAnyOf: aCollection [
	^ self
		on: [ :each | (aCollection includes: each) not ] message: 'any except ' , aCollection printString , ' expected'
		negated: [ :each | aCollection includes: each ] message: aCollection printString ,  ' not expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> anyOf: aCollection [
	^ self
		on: [ :each | aCollection includes: each ] message: 'any of ' , aCollection printString , ' expected'
		negated: [ :each | (aCollection includes: each) not ] message: 'none of ' , aCollection printString ,  'expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> between: min and: max [
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> blank [
	^ self chars: (String with: Character space with: Character tab) message: 'blank expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> char: aCharacter [
	^ self expect: aCharacter message: (String with: $" with: aCharacter with: $") , ' expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> char: aCharacter message: aString [
	^ self expect: aCharacter message: aString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> chars: aCollection message: aString [
	^ self on: (PPCharSetPredicate on: [ :char | aCollection includes: char ]) message: aString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> cr [
	^ self char: (Character codePoint: 13) message: 'carriage return expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> digit [
	^ self on: (PPCharSetPredicate on: [ :char | char isDigit ]) message: 'digit expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> endOfLine [
	
	^ PPEndOfLineParser new.
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> expect: anObject [
	^ self expect: anObject message: anObject printString , ' expected'
]

{ #category : #'factory-objects' }
PPPredicateObjectParser class >> expect: anObject message: aString [
	^ self 
		on: [ :each | each = anObject ] message: aString
		negated: [ :each | each ~= anObject ] message: 'no ' , aString
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> hex [
	^ self 
		on: (PPCharSetPredicate on: [ :char | 
			(char between: $0 and: $9) 
				or: [ (char between: $a and: $f) 
				or: [ (char between: $A and: $F) ] ] ])
		message: 'hex digit expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> letter [
	^ self on: (PPCharSetPredicate on: [ :char | char isLetter ]) message: 'letter expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> lf [
	^ self char: (Character codePoint: 10)
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> lowercase [
	^ self on: (PPCharSetPredicate on: [ :char | char isLowercase ]) message: 'lowercase letter expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> newline [
	^ self chars: (String with: (Character codePoint: 13) with: (Character codePoint: 10)) message: 'newline expected'
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
	^ self chars: '.,"''?!;:#$%&()*+-/<>=@[]\^_{}|~' message: 'punctuation expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> space [
	^ self on: (PPCharSetPredicate on: [ :char | char isSeparator ]) message: 'separator expected'
]

{ #category : #'instance creation' }
PPPredicateObjectParser class >> startOfLine [
	
	^ PPStartOfLineParser new.
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> tab [
	^ self char: Character tab message: 'tab expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> uppercase [
	^ self on: (PPCharSetPredicate on: [ :char | char isUppercase ]) message: 'uppercase letter expected'
]

{ #category : #'factory-chars' }
PPPredicateObjectParser class >> word [
	^ self on: (PPCharSetPredicate on: [ :char | char isAlphaNumeric ]) message: 'letter or digit expected'
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
PPPredicateObjectParser >> parseOn: aPPContext [
	^ (aPPContext atEnd not and: [ predicate value: aPPContext uncheckedPeek ])
		ifFalse: [ PPFailure message: predicateMessage context: aPPContext ]
		ifTrue: [ aPPContext next ]
]
