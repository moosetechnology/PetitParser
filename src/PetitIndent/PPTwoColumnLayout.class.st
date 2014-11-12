Class {
	#name : #PPTwoColumnLayout,
	#superclass : #PPCompositeParser,
	#instVars : [
		'identifier',
		'columnOne',
		'columnTwo',
		'blanks',
		'row',
		'firstRow',
		'lastRow'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> blanks [
	^ #blank asParser star
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> cleanupRow [
	"does nothing, just clear the indentation stack"
	^ columnOne forgetColumn, columnTwo forgetColumn
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> columnOne [
	^ identifier
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> columnTwo [
	^ identifier
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> firstRow [
	^ columnOne rememberColumn, blanks, columnTwo rememberColumn 
		==> [ :res | Array with: res first with: res third ]
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> identifier [
	^ (#letter asParser, #word asParser star) flatten  
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> lastRow [
	"does nothing, just clear the indentation stack"
	^ columnOne forgetColumn, columnTwo forgetColumn
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> row [
	^ columnOne selfAligned, blanks, columnTwo selfAligned 
		==> [ :res | Array with: res first with: res third ]
]

{ #category : #'as yet unclassified' }
PPTwoColumnLayout >> start [
	^ firstRow trim, row trim star, lastRow 
]
