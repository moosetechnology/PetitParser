Class {
	#name : #PPXPathGrammar,
	#superclass : #PPCompositeParserBridge,
	#instVars : [
		'node',
		'nameToken',
		'attributeNameToken',
		'index',
		'path',
		'multiple',
		'attributeFilter',
		'string',
		'whitespace'
	],
	#category : #'PetitXPath-Core'
}

{ #category : #accessing }
PPXPathGrammar >> attributeFilter [
	^ self attributeFilterAssigned / self attributeFilterPresent
]

{ #category : #accessing }
PPXPathGrammar >> attributeFilterAssigned [
	^ $[ asParser2, whitespace, attributeNameToken, whitespace, $= asParser2, whitespace, string, whitespace, $] asParser2 
		==> [ :nodes | 
			Array 
				with: nodes third
				with: nodes seventh ]
]

{ #category : #accessing }
PPXPathGrammar >> attributeFilterPresent [
	^ $[ asParser2, whitespace, attributeNameToken, whitespace, $] asParser2 
		==> [ :nodes | 
			Array 
				with: nodes third
				with: '*' ]
]

{ #category : #accessing }
PPXPathGrammar >> attributeNameToken [
	^ ($@ asParser2, ((#letter asParser2 / $_ asParser2 / $- asParser2) plus)) flatten
]

{ #category : #accessing }
PPXPathGrammar >> index [ 
	^$[ asParser2, #digit asParser2 plus, $] asParser2 
		==> [ :nodes | Number readFrom: nodes second readStream ]
]

{ #category : #accessing }
PPXPathGrammar >> multiple [
	^$* asParser2
]

{ #category : #accessing }
PPXPathGrammar >> nameToken [
	^ (#letter asParser2 / $_ asParser2 / $- asParser2) plus flatten
]

{ #category : #accessing }
PPXPathGrammar >> node [ 
	^nameToken, (multiple | index | attributeFilter) optional
]

{ #category : #accessing }
PPXPathGrammar >> path [ 
	^$/ asParser2 optional, node, ($/ asParser2, node ==> #second) star 
		==> [ :nodes | 
			OrderedCollection new
				add: nodes second;
				addAll: nodes third;
				asArray ]
]

{ #category : #accessing }
PPXPathGrammar >> start [ 
	^path end
]

{ #category : #accessing }
PPXPathGrammar >> string [
	^$" asParser2, $" asParser2 negate star flatten, $" asParser2
		==> [ :nodes | nodes second ]
]

{ #category : #accessing }
PPXPathGrammar >> whitespace [
	^ #space asParser2 star
]
