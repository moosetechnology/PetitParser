Class {
	#name : #PPCompareParser,
	#superclass : #PPParser,
	#instVars : [
		'compareBlock',
		'message',
		'column'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPCompareParser class >> on: compareBlock [
	^ self on: compareBlock message: compareBlock asString
]

{ #category : #'as yet unclassified' }
PPCompareParser class >> on: compareBlock message: message [
	^ (self basicNew
		initialize)
		compareBlock: compareBlock ;
		message: message;
		yourself
]

{ #category : #'as yet unclassified' }
PPCompareParser class >> on: compareBlock message: message column: column [
	^ (self basicNew
		initialize)
		compareBlock: compareBlock ;
		message: message;
		column: column;
		yourself
]

{ #category : #'as yet unclassified' }
PPCompareParser >> column [
	^ column
]

{ #category : #'as yet unclassified' }
PPCompareParser >> column: anInteger [
	column := anInteger
]

{ #category : #'as yet unclassified' }
PPCompareParser >> compareBlock: aBlock [
	compareBlock := aBlock
]

{ #category : #'as yet unclassified' }
PPCompareParser >> message: aString [
	message := aString
]

{ #category : #'as yet unclassified' }
PPCompareParser >> parseOn: context [
	^ (compareBlock value: context) ifTrue: [  
		compareBlock asString
	] ifFalse: [  
		PPFailure message: message context: context
	]
]
