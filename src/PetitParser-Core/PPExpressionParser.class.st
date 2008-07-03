Class {
	#name : #PPExpressionParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'add',
		'addop',
		'expr',
		'mul',
		'mulop',
		'pow',
		'powop',
		'num',
		'val'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #'productions-operations' }
PPExpressionParser >> add [
	^ (mul separatedBy: addop) foldLeft: [ :a :op :b | a perform: op with: b ]
]

{ #category : #'productions-operations' }
PPExpressionParser >> addop [
	^ ($+ asParser | $- asParser) flatten ==> #asSymbol
]

{ #category : #productions }
PPExpressionParser >> expr [
	^ $( asParser flatten , add , $) asParser flatten ==> #second
]

{ #category : #'productions-operations' }
PPExpressionParser >> mul [
	^ (pow separatedBy: mulop) foldLeft: [ :a :op :b | a perform: op with: b ]
]

{ #category : #'productions-operations' }
PPExpressionParser >> mulop [
	^ ($* asParser | $/ asParser) flatten ==> #asSymbol
]

{ #category : #productions }
PPExpressionParser >> num [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten ==> #asNumber
]

{ #category : #'productions-operations' }
PPExpressionParser >> pow [
	^ (val separatedBy: powop) foldRight: [ :a :op :b | a raisedTo: b ]
]

{ #category : #'productions-operations' }
PPExpressionParser >> powop [
	^ $^ asParser flatten ==> #asSymbol
]

{ #category : #accessing }
PPExpressionParser >> start [
	^ add end
]

{ #category : #productions }
PPExpressionParser >> val [
	^ num | expr
]
