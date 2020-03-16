"
A PPPreProcessingParserTest is xxxxxxxxx.

Instance Variables

Double inclusion:
yoyoLiYYbTeYYlTluTlYYeyoyo

==>

yoyoLiYYbeYYllulYYeyoyo

==>

yoyoLibelluleyoyo

"
Class {
	#name : #PPPreProcessingParserTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'preProcessingParser'
	],
	#category : #'PetitPreprocessor-Tests'
}

{ #category : #tests }
PPPreProcessingParserTest >> testBiggerReplacementThanMatching [
	preProcessingParser := 'Troll' asParser preProcessor: 'u' asParser ==> [ :p | 'll' ].
	self assert: (('Un' asParser , preProcessingParser , 'DeTroy' asParser) end matches: 'UnTrouDeTroy')
]

{ #category : #tests }
PPPreProcessingParserTest >> testDecomposedEntry [
	preProcessingParser := 'Libellule' asParser preProcessor: 'T' asParser ==> [ :p | '' ].
	self assert: (preProcessingParser end matches: 'LibTelTluTle')
]

{ #category : #tests }
PPPreProcessingParserTest >> testDecomposedEntryConsumed [
	preProcessingParser := 'Libellule' asParser preProcessor: 'T' asParser ==> [ :p | '' ].
	self assert: (preProcessingParser , 'yoyo' asParser matches: 'LibTelTluTleyoyo')
]

{ #category : #tests }
PPPreProcessingParserTest >> testDoNotConsumeIfContainedParserDoNotMatch [
	preProcessingParser := 'aNonMatchingString' asParser preProcessor: 'T' asParser ==> [ :p | '' ].
	self assert: (preProcessingParser optional , 'LibTelTluTle' asParser matches: 'LibTelTluTle')
]

{ #category : #tests }
PPPreProcessingParserTest >> testDoubleInclusion [
	| parser |
	preProcessingParser := ('Libellule' asParser preProcessor: 'Y' asParser plus ==> [ :p | '' ]) preProcessor: 'T' asParser ==> [ :p | '' ].
	parser := 'yoyo' asParser , preProcessingParser , 'yoyo' asParser.
	self assert: (parser matches: 'yoyoLiYYbTeYYlTluTlYYeyoyo')
]

{ #category : #tests }
PPPreProcessingParserTest >> testMixingDataToPreProcessAndNot [
	preProcessingParser := 'Libellule' asParser preProcessor: 'T' asParser ==> [ :p | '' ].
	self assert: ('DoNoTPreProcess' asParser , preProcessingParser , 'NotThisToo' asParser matches: 'DoNoTPreProcessLibTelTluTleNotThisToo')
]

{ #category : #tests }
PPPreProcessingParserTest >> testPreprocess [
	| preProcessor |
	preProcessor := PPrePParserStreamPreProcessor new.
	preProcessor matchingParser: 'T' asParser ==> [ :p | '' ].
	self assert: 'My String' equals: (preProcessor preProcess: 'MTy TStrTingT' asPetitStream) contents
]

{ #category : #tests }
PPPreProcessingParserTest >> testPreprocessWithPreviousContent [
	| preProcessor |
	preProcessor := PPrePParserStreamPreProcessor new.
	preProcessor matchingParser: 'T' asParser ==> [ :p | '' ].
	self
		assert: 'My String'
		equals:
			(preProcessor
				preProcess:
					('PreviousContentMTy TStrTingT' asPetitStream
						position: 15;
						yourself)) contents
]

{ #category : #tests }
PPPreProcessingParserTest >> testRelativePositionForDoubleInclusion [
	| token |
	preProcessingParser := ('yoyo' asParser , 'Libellule' asParser info , 'yoyo' asParser preProcessor: 'Y' asParser plus ==> [ :p | '' ])
		preProcessor: 'T' asParser ==> [ :p | '' ].
	token := (preProcessingParser parse: 'yTYYoyTYYoLiYYbTeYYlTluTlYYeyToYYyTo') second.
	self assert: token start equals: 11.
	self assert: token stop equals: 28
]

{ #category : #tests }
PPPreProcessingParserTest >> testRelativePositionForIncludedParser [
	| token |
	preProcessingParser := ('yoyo' asParser , 'Libellule' asParser info , 'yoyo' asParser preProcessor: 'Y' asParser plus ==> [ :p | '' ])
		preProcessor: 'T' asParser ==> [ :p | '' ].
	token := (preProcessingParser parse: 'yToyToLibTelTluTleyToyTo') second.
	self assert: token start equals: 7.
	self assert: token stop equals: 18
]

{ #category : #tests }
PPPreProcessingParserTest >> testWithPotentiallyPreprocessedDataAround [
	preProcessingParser := 'Libellule' asParser preProcessor: 'T' asParser ==> [ :p | '' ].
	self assert: (preProcessingParser end matches: 'TLibTelTluTleT')
]
