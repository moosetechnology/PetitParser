Class {
	#name : #PPManifestMfParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'pairs',
		'pair',
		'label',
		'oneLinerBasicValue',
		'pairValue',
		'valueSeparator'
	],
	#category : #PetitManifestMf
}

{ #category : #'as yet unclassified' }
PPManifestMfParser >> label [
	^ (#letter asParser / #digit asParser / $- asParser) star token trim flatten
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> oneLinerBasicValue [
	^ (PPPredicateObjectParser anyExceptAnyOf: {$: . $, . Character cr . Character lf . Character space})
		star flatten
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pair [
	^label , $: asParser token trim, pairValue ==> [:token | (token at: 1)->(token at: 3)]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pairValue [
	^ oneLinerBasicValue , ((valueSeparator , oneLinerBasicValue) ==> [:token | token last] ) trim star 
	
	==> [:token | 
		token last isEmpty 
			ifTrue: [token first] 
			ifFalse: [((OrderedCollection with: token first) addAll: token last; yourself) asArray  ]]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pairs [
	^ pair , (#newline asParser , pair ==> [:token | token second ]) star
	
	==> [:token | 
		((OrderedCollection with: token first) addAll: token last; yourself) asArray ]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> start [
	^ pairs end 
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> valueSeparator [
	^ $, asParser token , (#newline asParser , #space asParser)
	
]
