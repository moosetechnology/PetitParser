Class {
	#name : #PPXPathGrammar,
	#superclass : #PP2CompositeNode,
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
	^ $[ asPParser, whitespace, attributeNameToken, whitespace, $= asPParser, whitespace, string, whitespace, $] asPParser 
		==> [ :nodes | 
			Array 
				with: nodes third
				with: nodes seventh ]
]

{ #category : #accessing }
PPXPathGrammar >> attributeFilterPresent [
	^ $[ asPParser, whitespace, attributeNameToken, whitespace, $] asPParser 
		==> [ :nodes | 
			Array 
				with: nodes third
				with: '*' ]
]

{ #category : #accessing }
PPXPathGrammar >> attributeNameToken [
	^ ($@ asPParser, ((#letter asPParser / $_ asPParser / $- asPParser) plus)) flatten
]

{ #category : #accessing }
PPXPathGrammar >> index [ 
	^$[ asPParser, #digit asPParser plus, $] asPParser 
		==> [ :nodes | Number readFrom: nodes second readStream ]
]

{ #category : #accessing }
PPXPathGrammar >> multiple [
	^$* asPParser
]

{ #category : #accessing }
PPXPathGrammar >> nameToken [
	^ (#letter asPParser / $_ asPParser / $- asPParser) plus flatten
]

{ #category : #accessing }
PPXPathGrammar >> node [ 
	^nameToken, (multiple | index | attributeFilter) optional
]

{ #category : #accessing }
PPXPathGrammar >> path [ 
	^$/ asPParser optional, node, ($/ asPParser, node ==> #second) star 
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
	^$" asPParser, $" asPParser negate star flatten, $" asPParser
		==> [ :nodes | nodes second ]
]

{ #category : #accessing }
PPXPathGrammar >> whitespace [
	^ #space asPParser star
]
