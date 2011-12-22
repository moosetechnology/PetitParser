Class {
	#name : #PPXPathGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'node',
		'nameToken',
		'index',
		'path',
		'multiple',
		'attributeFilter',
		'string'
	],
	#category : #'PetitXPath-Core'
}

{ #category : #'as yet unclassified' }
PPXPathGrammar >> attributeFilter [
	^$[ asParser, nameToken, $= asParser, string, $] asParser 
		==> [ :nodes | 
			Array 
				with: nodes second 
				with: nodes fourth ]
]

{ #category : #'as yet unclassified' }
PPXPathGrammar >> index [ 
	^$[ asParser, #digit asParser plus, $] asParser 
		==> [ :nodes | Number readFrom: nodes second readStream ]
]

{ #category : #'as yet unclassified' }
PPXPathGrammar >> multiple [
	^$* asParser
]

{ #category : #'as yet unclassified' }
PPXPathGrammar >> nameToken [
	^ (#letter asParser / $_ asParser / $- asParser) plus flatten
]

{ #category : #'as yet unclassified' }
PPXPathGrammar >> node [ 
	^nameToken, (multiple | index | attributeFilter) optional
]

{ #category : #'as yet unclassified' }
PPXPathGrammar >> path [ 
	^$/ asParser optional, node, ($/ asParser, node ==> #second) star 
		==> [ :nodes | 
			OrderedCollection new
				add: nodes second;
				addAll: nodes third;
				asArray ]
]

{ #category : #'as yet unclassified' }
PPXPathGrammar >> start [ 
	^path end
]

{ #category : #'as yet unclassified' }
PPXPathGrammar >> string [
	^$" asParser, $" asParser negate star flatten, $" asParser
		==> [ :nodes | nodes second ]
]
