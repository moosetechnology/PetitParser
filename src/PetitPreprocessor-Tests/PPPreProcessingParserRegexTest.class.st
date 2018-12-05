Class {
	#name : #PPPreProcessingParserRegexTest,
	#superclass : #PPAbstractParserTest,
	#category : 'PetitPreprocessor-Tests'
}

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testBiggerReplacementThanMatching [
	|preProcessingParser|	
	preProcessingParser := 'Troll' asParser preProcess: ('u' asRegex) into: 'll'. 
	self assert: (('Un' asParser, preProcessingParser, 'DeTroy' asParser) end matches: 'UnTrouDeTroy')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testDecomposedEntry [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert: (preProcessingParser end matches: 'LibTelTluTle')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testDecomposedEntryConsumed [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert:  ((preProcessingParser, 'yoyo' asParser) matches:  'LibTelTluTleyoyo')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testDoNotConsumeIfContainedParserDoNotMatch [
	|preProcessingParser|	
	preProcessingParser :=  'aNonMatchingString' asParser preProcess: 'T' asRegex into: ''.
	self assert: ((preProcessingParser optional, 'LibTelTluTle' asParser) matches: 'LibTelTluTle')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testDoubleInclusion [
	| preProcessingParser parser |
	preProcessingParser := ('Libellule' asParser preProcess: 'Y+' asRegex into: '') preProcess: 'T' asRegex  into: ''.
	parser :=  'yoyo' asParser, preProcessingParser, 'yoyo' asParser.
	self assert: (parser matches: 'yoyoLiYYbTeYYlTluTlYYeyoyo').
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testMixingDataToPreProcessAndNot [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert: (('DoNoTPreProcess' asParser, preProcessingParser, 'NotThisToo' asParser) matches: 'DoNoTPreProcessLibTelTluTleNotThisToo')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testPreprocess [
	| preProcessor |
	preProcessor := PPreRegexStreamPreProcessor new.
	preProcessor regex: 'T' asRegex .
	preProcessor replacement: ''.
	self assert: 'My String' equals: (preProcessor preProcess: 'MTy TStrTingT' asPetitStream ) contents 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testPreprocessWithPreviousContent [
	| aStream preProcessor |
	preProcessor := PPreRegexStreamPreProcessor new.
	preProcessor regex: 'T' asRegex .
	preProcessor replacement: ''.
	self assert: 'My String' equals: (preProcessor preProcess: ('PreviousContentMTy TStrTingT' asPetitStream position: 15; yourself)) contents 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testRelativePositionForDoubleInclusion [
	|preProcessingParser token |	
	preProcessingParser := (('yoyo' asParser, ('Libellule' asParser info), 'yoyo' asParser) preProcess: 'Y+' asRegex into: '') preProcess: 'T' asRegex  into: ''.
	token := (preProcessingParser parse:  'yTYYoyTYYoLiYYbTeYYlTluTlYYeyToYYyTo') second.
	self assert: token start equals: 11.
	self assert: token stop equals: 28. 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testRelativePositionForIncludedParser [
	|preProcessingParser token |	
	preProcessingParser := (('yoyo' asParser, ('Libellule' asParser info), 'yoyo' asParser) preProcess: 'Y+' asRegex into: '') preProcess: 'T' asRegex  into: ''.
	token := (preProcessingParser parse:  'yToyToLibTelTluTleyToyTo') second.
	self assert: token start equals: 7.
	self assert: token stop equals: 18. 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserRegexTest >> testWithPotentiallyPreprocessedDataAround [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcess: 'T' asRegex into: ''.
	self assert: (preProcessingParser end matches: 'TLibTelTluTleT')
]
