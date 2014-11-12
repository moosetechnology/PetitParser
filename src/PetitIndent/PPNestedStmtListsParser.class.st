Class {
	#name : #PPNestedStmtListsParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'list',
		'command',
		'indent',
		'dedent'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
PPNestedStmtListsParser >> command [
	^ (#letter asParser, (#letter asParser / #digit asParser) star) flatten
]

{ #category : #'as yet unclassified' }
PPNestedStmtListsParser >> dedent [
	^ #dedent asParser
]

{ #category : #'as yet unclassified' }
PPNestedStmtListsParser >> indent [
	^ #indent asParser
]

{ #category : #'as yet unclassified' }
PPNestedStmtListsParser >> list [
	^ 
		(indent,
			(list / command) trimWithoutIndents star,
		dedent) ==> #second
]

{ #category : #'as yet unclassified' }
PPNestedStmtListsParser >> start [
	^ list end
]
