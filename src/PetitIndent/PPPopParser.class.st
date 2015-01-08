Class {
	#name : #PPPopParser,
	#superclass : #PPParser,
	#instVars : [
		'ref'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPPopParser >> acceptsEpsilon [
	^ true
]

{ #category : #'as yet unclassified' }
PPPopParser >> initialize [ 
	ref := PPIndentationLevel instance
]

{ #category : #'as yet unclassified' }
PPPopParser >> parseOn: aPPContext [
	| value |
	(value := aPPContext indentTraces pop: ref) ifNil: [ 
		^ PPFailure message: 'cannot pop anymore' context: aPPContext
	].
	
	^ 'poped column: ', (aPPContext stream column: value) asString
]

{ #category : #'as yet unclassified' }
PPPopParser >> ref: anObject [
	ref := anObject.
]
