Class {
	#name : #PPExpressionParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #'productions-operations' }
PPExpressionParser >> add [
	(mul separatedBy: addop) ==> [ :node | self evalArray: node ]
]

{ #category : #'productions-operations' }
PPExpressionParser >> addop [
	($+ | $-) flatten ==> #asSymbol
]

{ #category : #private }
PPExpressionParser >> evalArray: anArray [
	| collection |
	collection := OrderedCollection withAll: anArray.
	[ collection size > 1 ] whileTrue: [
		collection addFirst: (collection removeFirst 
			perform: collection removeFirst 
			with: collection removeFirst) ].
	^ collection first
]

{ #category : #productions }
PPExpressionParser >> expr [
	$( flatten , add , $) flatten ==> #second
]

{ #category : #'productions-operations' }
PPExpressionParser >> mul [
	(val separatedBy: mulop) ==> [ :node | self evalArray: node ]
]

{ #category : #'productions-operations' }
PPExpressionParser >> mulop [
	($* | $/) flatten ==> #asSymbol
]

{ #category : #productions }
PPExpressionParser >> num [
	($- optional , #digit plus , ($. , #digit plus) optional) flatten ==> #asNumber
]

{ #category : #accessing }
PPExpressionParser >> start [
	add end
]

{ #category : #productions }
PPExpressionParser >> val [
	num | expr
]
