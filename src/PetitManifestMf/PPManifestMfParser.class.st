Class {
	#name : #PPManifestMfParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'pairs',
		'pair',
		'label',
		'value',
		'basicValue',
		'oneLinerBasicValue'
	],
	#category : #PetitManifestMf
}

{ #category : #'as yet unclassified' }
PPManifestMfParser >> basicValue [
	^ oneLinerBasicValue , ((#newline asParser , #space asParser) , oneLinerBasicValue ==> #second) star
	
	==> [:token | 
		((OrderedCollection with: token first) addAll: token last; yourself) asArray ]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> label [
	^ (#letter asParser / #digit asParser / $- asParser) star token trim flatten
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> oneLinerBasicValue [
	| aCollectionOfChars |
	aCollectionOfChars := {$: . $, . Character cr . Character lf}.
	parser := PPPredicateObjectParser
		on: [:each | (aCollectionOfChars includes: each) not ]
		message: 'any except ' , aCollectionOfChars printString , ' expected'.
	^ parser star flatten 
		
		"anyExceptAnyOf: #($: $, )) star flatten"
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pair [
	^label , $: asParser token trim, value ==> [:token | (token at: 1)->(token at: 3)]
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
PPManifestMfParser >> value [
	^ basicValue , 
	(($, asParser trim token , basicValue) ==> [:token | token second] ) trim star 
	
	==> [:token | 
		token last isEmpty 
			ifTrue: [token first] 
			ifFalse: [((OrderedCollection with: token first) addAll: token last; yourself) asArray  ]]
]
