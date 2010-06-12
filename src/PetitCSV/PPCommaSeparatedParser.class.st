Class {
	#name : #PPCommaSeparatedParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'row',
		'cell',
		'rows',
		'endOfLine',
		'whitespace'
	],
	#category : #PetitCSV
}

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> cell [
	^ whitespace star , ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token , whitespace star
		==> [ :nodes | nodes second value asNumber ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> endOfLine [
	^ #newline asParser token
	"(#cr asParser , #lf asParser optional) / #lf asParser"
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> row [
	^ (cell delimitedBy: $, asParser token) ==> [ :nodes | nodes reject: [ :each | each class = PPToken ] ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> rows [
	^ (row delimitedBy: endOfLine)  ==> [ :nodes | nodes reject: [ :each | each class = PPToken ] ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> start [
	^ rows end
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> whitespace [
	^ PPPredicateObjectParser anyOf: (Array with: Character space with: Character tab)
]
