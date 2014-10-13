Class {
	#name : #PPSmalltalkWhitespaceParser,
	#superclass : #PPParser,
	#instVars : [
		'separator'
	],
	#category : #'PetitSmalltalk-Core'
}

{ #category : #initialization }
PPSmalltalkWhitespaceParser >> initialize [
	super initialize.
	separator := PPCharSetPredicate on: [ :char | char isSeparator ].
]

{ #category : #analysis }
PPSmalltalkWhitespaceParser >> isNullable [
	^ true
]

{ #category : #parsing }
PPSmalltalkWhitespaceParser >> parseOn: aPPContext [
	[ [aPPContext atEnd not and: [ separator value: aPPContext uncheckedPeek ] ]
		whileTrue: [ aPPContext next ].
		
	 aPPContext atEnd not and: [ aPPContext uncheckedPeek = $" ] ] whileTrue: [
		aPPContext next.
		aPPContext upTo: $".
	].
]
