Class {
	#name : #PPValidator,
	#superclass : #Object,
	#instVars : [
		'parser',
		'productions',
		'firstSets',
		'followSets'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'instance-creation' }
PPValidator class >> on: aParser [
	^ self basicNew initializeOn: aParser
]

{ #category : #initialization }
PPValidator >> initializeOn: aParser [
	parser := aParser.
	productions := aParser allNodes.
	firstSets := aParser firstSets.
	followSets := aParser followSets
]

{ #category : #'testing-LL(1)' }
PPValidator >> validateFirstFirstConflict [
	"FIRST/FIRST conflict: The FIRST sets of two different non-terminals are overlapping."
	
	| reverseSets |
	reverseSets := IdentityDictionary new.
	firstSets keysAndValuesDo: [ :production :firstSet |
		production isTerminal ifFalse: [ 
			firstSet do: [ :other |
				(reverseSets at: other ifAbsentPut: [ IdentitySet new ])
					add: production ] ] ].
	reverseSets keysAndValuesDo: [ :production :reverseSet |
		reverseSet size > 1 
			ifTrue: [ Transcript show: 'LL(1): First-First Conflict: '; show: reverseSet; cr ] ]
]

{ #category : #'testing-LL(1)' }
PPValidator >> validateFirstFollowConflict [
	"FIRST/FOLLOW conflict: The FIRST and FOLLOW set of a grammar rule overlap. With an epsilon in the FIRST set it is unknown which alternative to select."
	
	| firstSet followSet |
	productions do: [ :production |
		firstSet := firstSets at: production.
		(firstSet anySatisfy: [ :each | each isNullable ]) ifTrue: [
			followSet := followSets at: production.
			(firstSet intersection: followSet) isEmpty
				ifFalse: [ Transcript show: 'LL(1): First-Follow Conflict: '; show: production; cr ] ] ]
]
