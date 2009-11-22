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
	^ (factors separatedBy: ($+ asParser / $- asParser) token) 
		foldLeft: [ :a :op :b | a perform: op value asSymbol with: b ]
]

{ #category : #grammar }
PPExpressionParser >> factors [
	^ multiplication / power
]

{ #category : #grammar }
PPExpressionParser >> multiplication [
	^ (power separatedBy: ($* asParser / $/ asParser) token)
		foldLeft: [ :a :op :b | a perform: op value asSymbol with: b ]
]

{ #category : #grammar }
PPExpressionParser >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token ==> [ :token | token value asNumber ]
]

{ #category : #grammar }
PPExpressionParser >> parentheses [
	^ $( asParser flatten , terms , $) asParser flatten ==> #second
]

{ #category : #grammar }
PPExpressionParser >> power [
	^ (primary separatedBy: $^ asParser token) foldRight: [ :a :op :b | a raisedTo: b ]
]

{ #category : #grammar }
PPExpressionParser >> primary [
	^ number / parentheses
]

{ #category : #accessing }
PPExpressionParser >> start [
	^ terms end
]

{ #category : #grammar }
PPExpressionParser >> terms [
	^ addition / factors
]
