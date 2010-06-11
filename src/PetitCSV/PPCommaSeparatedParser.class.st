Class {
	#name : #PPCommaSeparatedParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'row',
		'cell'
	],
	#category : #PetitCSV
}

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> cell [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) token trim ==> [ :token | token value asNumber ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> row [
	^ cell,  ($, asParser token, cell ==> [:tokens | tokens last ]) star ==> [:tokens | (OrderedCollection with: tokens first) addAll: tokens last ]
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParser >> start [
	^ row end
]
