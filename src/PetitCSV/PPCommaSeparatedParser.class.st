Class {
	#name : #PPCommaSeparatedParser,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'row',
		'cell',
		'rows',
		'endOfLine',
		'whitespace',
		'nonComma'
	],
	#category : #PetitCSV
}

{ #category : #accessing }
PPCommaSeparatedParser >> cell [
	^ whitespace star , nonComma star flatten , whitespace star
		==> [ :nodes | nodes second value ]
]

{ #category : #accessing }
PPCommaSeparatedParser >> endOfLine [
	^ #newline asPParser token
]

{ #category : #accessing }
PPCommaSeparatedParser >> nonComma [
	^ PP2PredicateObjectNode noneOf: {Character space . Character tab . Character cr . Character lf . $, }
]

{ #category : #accessing }
PPCommaSeparatedParser >> number [ 
	^ ($- asPParser optional , #digit asPParser plus , ($. asPParser , #digit asPParser plus) optional) token
		==> [ :nodes | nodes first value asNumber ]
]

{ #category : #accessing }
PPCommaSeparatedParser >> row [
	^ (cell delimitedBy: $, asPParser token) ==> [ :nodes | nodes reject: [ :each | each isToken ] ]
]

{ #category : #accessing }
PPCommaSeparatedParser >> rows [
	^ (row delimitedBy: endOfLine)  ==> [ :nodes | nodes reject: [ :each | each isToken ] ]
]

{ #category : #accessing }
PPCommaSeparatedParser >> start [
	^ rows end
]

{ #category : #accessing }
PPCommaSeparatedParser >> whitespace [
	^ #blank asPParser
]
