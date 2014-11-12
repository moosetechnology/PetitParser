Class {
	#name : #PPPopParser,
	#superclass : #PPParser,
	#instVars : [
		'ref'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPPopParser >> initialize [ 
	ref := PPIndentationLevel instance
]

{ #category : #'as yet unclassified' }
PPPopParser >> parseOn: aPPContext [
	(aPPContext indentTraces pop: ref) ifNil: [ 
		^ PPFailure message: 'cannot pop anymore' context: aPPContext
	].
	^ #pop
]

{ #category : #'as yet unclassified' }
PPPopParser >> ref: anObject [
	ref := anObject.
]
