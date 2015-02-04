Class {
	#name : #PPPushParser,
	#superclass : #PPParser,
	#instVars : [
		'ref'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPPushParser >> acceptsEpsilon [
	^ true
]

{ #category : #'as yet unclassified' }
PPPushParser >> initialize [ 
	ref := PPIndentationLevel instance
]

{ #category : #'as yet unclassified' }
PPPushParser >> parseOn: aPPContext [
	aPPContext indentTraces push: ref column: aPPContext stream column.
	^ 'pushed at column: ', aPPContext stream column asString
]

{ #category : #'as yet unclassified' }
PPPushParser >> ref: anObject [
	ref := anObject.
]
