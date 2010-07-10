Class {
	#name : #PPManifestMfParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'pairs',
		'pair',
		'label',
		'value'
	],
	#category : #PetitManifestMf
}

{ #category : #'as yet unclassified' }
PPManifestMfParser >> label [
	^ (#letter asParser / #digit asParser) star token trim flatten
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pair [
	^ label , $: asParser token , value ==> [:token | (token at: 1)->(token at: 3)]
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> pairs [
	^ pair star
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> start [
	^ pairs end
]

{ #category : #'as yet unclassified' }
PPManifestMfParser >> value [
	^ (PPPredicateObjectParser anyExcept: $: asParser) star token trim flatten
]
