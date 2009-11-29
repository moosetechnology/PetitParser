Class {
	#name : #PPArithmeticParser,
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
	#category : #'PetitParser-Tests'
}

{ #category : #grammar }
PPArithmeticParser >> addition [
	^ (factors separatedBy: ($+ asParser / $- asParser) token) 
		foldLeft: [ :a :op :b | a perform: op value asSymbol with: b ]
]

{ #category : #grammar }
PPArithmeticParser >> factors [
	^ multiplication / power
]

{ #category : #grammar }
PPArithmeticParser >> multiplication [
	^ (power separatedBy: ($* asParser / $/ asParser) token)
		foldLeft: [ :a :op :b | a perform: op value asSymbol with: b ]
]

{ #category : #grammar }
PPArithmeticParser >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token ==> [ :token | token value asNumber ]
]

{ #category : #grammar }
PPArithmeticParser >> parentheses [
	^ $( asParser flatten , terms , $) asParser flatten ==> #second
]

{ #category : #grammar }
PPArithmeticParser >> power [
	^ (primary separatedBy: $^ asParser token) foldRight: [ :a :op :b | a raisedTo: b ]
]

{ #category : #grammar }
PPArithmeticParser >> primary [
	^ number / parentheses
]

{ #category : #accessing }
PPArithmeticParser >> start [
	^ terms end
]

{ #category : #grammar }
PPArithmeticParser >> terms [
	^ addition / factors
]
