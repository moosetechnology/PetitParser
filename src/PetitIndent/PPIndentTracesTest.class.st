Class {
	#name : #PPIndentTracesTest,
	#superclass : #TestCase,
	#instVars : [
		'traces',
		'il'
	],
	#category : #'PetitIndent-Tests'
}

{ #category : #'as yet unclassified' }
PPIndentTracesTest >> setUp [
	traces := IndentTraces new.
	il := PPIndentationLevel instance.
]

{ #category : #'as yet unclassified' }
PPIndentTracesTest >> testContextIndentTraces [
	| context |
	context := PPContext new.
	
	context indentTraces push: 3.
	context indentTraces push: 3.
	self assert: (context indentTraces tracesFor: il) size = 3.
	self assert: context indentTraces lastIndent = 3.
	self assert: context lastIndent = 3.
]

{ #category : #'as yet unclassified' }
PPIndentTracesTest >> testPush [
	traces push: 2.
	self assert: traces lastIndent = 2.
	traces push: 3.
	self assert: traces lastIndent = 3.
	self assert: (traces tracesFor: il) size = 3.

	traces push: 3.
	self assert: (traces tracesFor: il) size = 4.
	
	traces push: traces lastIndent.
	self assert: (traces tracesFor: il) size = 5.


]
