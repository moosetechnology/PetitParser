Class {
	#name : #PPPreProcessingParserRegexTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'preProcessingParser'
	],
	#category : #'PetitPreprocessor-Tests'
}

{ #category : #tests }
PPPreProcessingParserRegexTest >> testBiggerReplacementThanMatching [
	preProcessingParser := 'Troll' asParser preProcess: 'u' asRegex into: 'll'.
	self assert: (('Un' asParser , preProcessingParser , 'DeTroy' asParser) end matches: 'UnTrouDeTroy')
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testDecomposedEntry [
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert: (preProcessingParser end matches: 'LibTelTluTle')
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testDecomposedEntryConsumed [
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert: (preProcessingParser , 'yoyo' asParser matches: 'LibTelTluTleyoyo')
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testDoNotConsumeIfContainedParserDoNotMatch [
	preProcessingParser := 'aNonMatchingString' asParser preProcess: 'T' asRegex into: ''.
	self assert: (preProcessingParser optional , 'LibTelTluTle' asParser matches: 'LibTelTluTle')
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testDoubleInclusion [
	| parser |
	preProcessingParser := ('Libellule' asParser preProcess: 'Y+' asRegex into: '') preProcess: 'T' asRegex into: ''.
	parser := 'yoyo' asParser , preProcessingParser , 'yoyo' asParser.
	self assert: (parser matches: 'yoyoLiYYbTeYYlTluTlYYeyoyo')
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testMixingDataToPreProcessAndNot [
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert: ('DoNoTPreProcess' asParser , preProcessingParser , 'NotThisToo' asParser matches: 'DoNoTPreProcessLibTelTluTleNotThisToo')
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testPreprocess [
	| preProcessor |
	preProcessor := PPreRegexStreamPreProcessor new
		regex: 'T' asRegex;
		replacement: '';
		yourself.
	self assert: 'My String' equals: (preProcessor preProcess: 'MTy TStrTingT' asPetitStream) contents
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testPreprocessWithPreviousContent [
	| preProcessor |
	preProcessor := PPreRegexStreamPreProcessor new
		regex: 'T' asRegex;
		replacement: '';
		yourself.
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
PPPreProcessingParserRegexTest >> testRelativePositionForDoubleInclusion [
	| token |
	preProcessingParser := ('yoyo' asParser , 'Libellule' asParser info , 'yoyo' asParser preProcess: 'Y+' asRegex into: '') preProcess: 'T' asRegex into: ''.
	token := (preProcessingParser parse: 'yTYYoyTYYoLiYYbTeYYlTluTlYYeyToYYyTo') second.
	self assert: token start equals: 11.
	self assert: token stop equals: 28
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testRelativePositionForIncludedParser [
	| token |
	preProcessingParser := ('yoyo' asParser , 'Libellule' asParser info , 'yoyo' asParser preProcess: 'Y+' asRegex into: '') preProcess: 'T' asRegex into: ''.
	token := (preProcessingParser parse: 'yToyToLibTelTluTleyToyTo') second.
	self assert: token start equals: 7.
	self assert: token stop equals: 18
]

{ #category : #tests }
PPPreProcessingParserRegexTest >> testWithPotentiallyPreprocessedDataAround [
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert: (preProcessingParser end matches: 'TLibTelTluTleT')
]
