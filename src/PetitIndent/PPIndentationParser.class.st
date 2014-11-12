Class {
	#name : #PPIndentationParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'ref',
		'context'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPIndentationParser class >> on: aPPParser ref: whatever [
	^ (self on: aPPParser)
		ref: whatever;
		yourself.
]

{ #category : #'as yet unclassified' }
PPIndentationParser >> initialize [ 
	ref := PPIndentationLevel instance
]

{ #category : #'as yet unclassified' }
PPIndentationParser >> isIndentationParser [
	^ true
]

{ #category : #'as yet unclassified' }
PPIndentationParser >> lastIndent [
	^ context indentTraces lastIndentOf: ref.
]

{ #category : #'as yet unclassified' }
PPIndentationParser >> lastLine [
	^ context indentTraces lastLineOf: ref.
]

{ #category : #'as yet unclassified' }
PPIndentationParser >> ref [
	^ ref
]

{ #category : #'as yet unclassified' }
PPIndentationParser >> ref: anObject [
	""
	ref := anObject
]
