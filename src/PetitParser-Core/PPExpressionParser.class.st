Class {
	#name : #PPExpressionParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'terms',
		'addition',
		'factors',
		'multiplication',
		'power',
		'primary',
		'parentheses',
		'number'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #grammar }
PPExpressionParser >> addition [
	^ (factors separatedBy: ($+ asParser | $- asParser) flatten) 
		foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]
]

{ #category : #grammar }
PPExpressionParser >> factors [
	^ multiplication | division | power
]

{ #category : #grammar }
PPExpressionParser >> multiplication [
	^ (power separatedBy: ($* asParser | $/ asParser) flatten)
		foldLeft: [ :a :op :b | a perform: op asSymbol with: b ]
]

{ #category : #grammar }
PPExpressionParser >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten ==> #asNumber
]

{ #category : #grammar }
PPExpressionParser >> parentheses [
	^ $( asParser flatten , terms , $) asParser flatten ==> #second
]

{ #category : #grammar }
PPExpressionParser >> power [
	^ (primary separatedBy: $^ asParser flatten) foldRight: [ :a :op :b | a raisedTo: b ]
]

{ #category : #grammar }
PPExpressionParser >> primary [
	^ number | parentheses
]

{ #category : #accessing }
PPExpressionParser >> start [
	^ terms end
]

{ #category : #grammar }
PPExpressionParser >> terms [
	^ addition | factors
]
