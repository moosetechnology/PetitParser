Class {
	#name : #PPManifestMfParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'pairs',
		'pair',
		'label',
		'oneLinerBasicValue',
		'pairValue',
		'valueSeparator',
		'basicValue',
		'newline'
	],
	#category : #PetitManifestMf
}

{ #category : #'as yet unclassified' }
PPManifestMfParser >> basicValue [
	^ oneLinerBasicValue , ((newline , #space asParser) , oneLinerBasicValue ==> #last) star
	
	==> [:token | 
		((OrderedCollection with: token first) addAll: token second; yourself) asArray ]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> label [
	^ (#letter asParser / #digit asParser / $- asParser) star token
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> newline [
	^ (Character lf asParser)
	/ (Character cr asParser , Character lf asParser optional)
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> oneLinerBasicValue [
	^ (PPPredicateObjectParser anyExceptAnyOf: {($, asParser) . Character cr . Character lf })
		star
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pair [
	^label , $: asParser token trim, pairValue ==> [:token | (token at: 1)->(token at: 3)]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pairValue [
	^ basicValue , ((valueSeparator , basicValue) ==> [:token | token last] ) star 
	
	==> [:token | 
		token last isEmpty 
			ifTrue: [token first] 
			ifFalse: [((OrderedCollection with: token first) addAll: token last; yourself) asArray  ]]
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
	^ $, asParser token
]
