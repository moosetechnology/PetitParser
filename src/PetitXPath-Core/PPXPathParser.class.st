Class {
	#name : #PPXPathParser,
	#superclass : #PPXPathGrammar,
	#category : #'PetitXPath-Core'
}

{ #category : #'as yet unclassified' }
PPXPathParser >> attributeFilter [ 
	^super attributeFilter 
		==> [ :nodes | PPXPathAttributeFilter withName: nodes first value: nodes second ]
]

{ #category : #'as yet unclassified' }
PPXPathParser >> index [ 
	^super index 
		==>[ :nodes | PPXPathIndexFilter withIndex: nodes ]
]

{ #category : #'as yet unclassified' }
PPXPathParser >> multiple [ 
	^super multiple ==> [ :nodes | PPXPathMultipleFilter new ]
]

{ #category : #'as yet unclassified' }
PPXPathParser >> node [ 
	^super node 
		==> [ :nodes | 
			PPXPathNode withTag: nodes first filter: nodes second ]
]
