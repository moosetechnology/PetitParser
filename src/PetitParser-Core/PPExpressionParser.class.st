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
	($+ | $-) token ==> [ :node | node asSymbol ]
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
	$( token , add , $) token ==> [ :node | node second ]
]

{ #category : #'productions-operations' }
PPExpressionParser >> mul [
	(val separatedBy: mulop) ==> [ :node | self evalArray: node ]
]

{ #category : #'productions-operations' }
PPExpressionParser >> mulop [
	($* | $/) token ==> [ :node | node asSymbol ]
]

{ #category : #productions }
PPExpressionParser >> num [
	($- optional , #digit plus , ($. , #digit plus) optional) token ==> [ :node | node asNumber ]
]

{ #category : #accessing }
PPExpressionParser >> startProduction [
	add end
]

{ #category : #productions }
PPExpressionParser >> val [
	num | expr
]
