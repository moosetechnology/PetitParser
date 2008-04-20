"
A parser that accepts if a given predicate holds.
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
	#category : #'PetitParser-Core'
}

{ #category : #'factory-objects' }
PPPredicateParser class >> any [
	^ self
		on: [ :each | true ] message: 'something expected'
		negated: [ :each | false ] message: 'nothing expected'
]

{ #category : #'factory-objects' }
PPPredicateParser class >> between: min and: max [
	^ self
		on: [ :each | each >= min and: [ each <= max ] ] message: min printString , '..' , max printString , ' expected'
		negated: [ :each | each < min or: [ each > max ] ] message: min printString , '..' , max printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> char: aCharacter [
	^ self expect: aCharacter
]

{ #category : #'factory-chars' }
PPPredicateParser class >> control [
	^ self
		on: [ :each | each asInteger < 32 ] message: 'control character expected'
		negated: [ :each | each asInteger >= 32 ] message: 'no control character expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> digit [
	^ self 
		on: [ :each | each isDigit ] message: 'digit expected'
		negated: [ :each | each isDigit not ] message: 'no digit expected'
]

{ #category : #'factory-objects' }
PPPredicateParser class >> expect: anObject [
	^ self 
		on: [ :each | each = anObject ] message: anObject printString , ' expected'
		negated: [ :each | each ~= anObject ] message: anObject printString , ' not expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> letter [
	^ self 
		on: [ :each | each isLetter ] message: 'letter expected'
		negated: [ :each | each isLetter not ] message: 'no letter expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> lowercase [
	^ self
		on: #isLowercase message: 'lowercase letter expected'
		negated: #isUppercase message: 'uppercase letter expected'
]

{ #category : #'instance-creation' }
PPPredicateParser class >> on: aBlock message: aString [
	^ self on: aBlock message: aString negated: [ :each | (aBlock value: each) not ] message: 'no ' , aString
]

{ #category : #'instance-creation' }
PPPredicateParser class >> on: aBlock message: aString negated: aNegatedBlock message: aNegatedString [
	^ self new initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString
]

{ #category : #'factory-chars' }
PPPredicateParser class >> space [
	^ self 
		on: [ :each | each isSeparator ] message: 'separator expected'
		negated: [ :each | each isSeparator not ] message: 'no separator expected'
]

{ #category : #'factory-chars' }
PPPredicateParser class >> uppercase [
	^ self lowercase not
]

{ #category : #'factory-chars' }
PPPredicateParser class >> word [
	^ self 
		on: [ :each | each isAlphaNumeric ] message: 'letter or digit expected'
		negated: [ :each | each isAlphaNumeric not ] message: 'no letter or digit expected'
]

{ #category : #initialization }
PPPredicateParser >> initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString [ 
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString
]

{ #category : #operators }
PPPredicateParser >> not [
	"Negate the receiving predicate parser."
	
	^ PPPredicateParser on: negated message: negatedMessage negated: predicate message: predicateMessage
]

{ #category : #parsing }
PPPredicateParser >> parse: aStream [
	^ (aStream atEnd not and: [ predicate value: aStream peek ])
		ifFalse: [ PPFailure reason: predicateMessage position: aStream position ]
		ifTrue: [ aStream next ]
]

{ #category : #printing }
PPPredicateParser >> printOn: aStream [
	aStream nextPut: $<; nextPutAll: predicateMessage; nextPut: $>
]
