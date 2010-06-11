Class {
	#name : #PPCommaSeparatedParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'row',
		'cell',
		'rows',
		'endOfLine'
	],
	#category : #PetitCSV
}

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> cell [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token trim ==> [ :token | token value asNumber ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> endOfLine [
	^ #newline asParser
	"(#cr asParser , #lf asParser optional) / #lf asParser"
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> row [
	^ cell ,  ($, asParser token , cell ==> [:tokens | tokens last ]) star
		==> [ :tokens | (Array withAll: tokens last) copyWithFirst: tokens first ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> rows [
	^ row , (endOfLine , row ==> [:tokens | tokens last ]) star 
		==> [:tokens | (Array withAll: tokens last) copyWithFirst: tokens first ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> start [
	^ rows end
]
