Class {
	#name : #PPManifestMfParser,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'pairs',
		'pair',
		'label',
		'basicValue',
		'oneLinerBasicValue',
		'pairValue',
		'newline',
		'valueSeparator'
	],
	#category : #PetitManifestMf
}

{ #category : #'as yet unclassified' }
PPManifestMfParser >> basicValue [
	^ oneLinerBasicValue , ((newline , #space asPParser) , oneLinerBasicValue ==> #last) star
	
	==> [:token | 
		((OrderedCollection with: token first inspect) addAll: token second; yourself) asArray ]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> label [
	^ (#letter asPParser / #digit asPParser / $- asPParser) star flatten trim
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> newline [
	^ (Character lf asPParser)
	/ (Character cr asPParser , Character lf asPParser optional)
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> oneLinerBasicValue [
	^ (PP2PredicateObjectNode noneOf: {$, . Character cr . Character lf })
		star flatten
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pair [
	^label , $: asPParser token trim, pairValue ==> [:token | (token at: 1)->(token at: 3)]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pairValue [
	^ oneLinerBasicValue , ((valueSeparator , oneLinerBasicValue) ==> [:token | token last] ) star
	
	==> [:token | 
		((OrderedCollection with: token first) addAll: token last; yourself) asArray ]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pairs [
	^ pair , (newline , pair ==> [:token | token second ]) star, newline star
	
	==> [:token | 
		((OrderedCollection with: token first) addAll: token second; yourself) asArray ]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> start [
	^ pairs end 
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> valueSeparator [
	^ $, asPParser token trim
]
