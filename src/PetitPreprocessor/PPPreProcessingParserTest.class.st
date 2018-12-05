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
	#category : #'PetitPreprocessor-Tests'
}

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testBiggerReplacementThanMatching [
	|preProcessingParser|	
	preProcessingParser := 'Troll' asParser preProcessor: ('u' asParser ==> [:p | 'll']). 
	self assert: (('Un' asParser, preProcessingParser, 'DeTroy' asParser) end matches: 'UnTrouDeTroy')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testDecomposedEntry [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcessor: ('T' asParser ==> [:p | '']).
	self assert: (preProcessingParser end matches: 'LibTelTluTle')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testDecomposedEntryConsumed [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcessor: ('T' asParser ==> [:p | '']).
	self assert:  ((preProcessingParser, 'yoyo' asParser) matches:  'LibTelTluTleyoyo')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testDoNotConsumeIfContainedParserDoNotMatch [
	|preProcessingParser|	
	preProcessingParser :=  'aNonMatchingString' asParser preProcessor: ('T' asParser ==> [:p | '']).
	self assert: ((preProcessingParser optional, 'LibTelTluTle' asParser) matches: 'LibTelTluTle')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testDoubleInclusion [
	| preProcessingParser parser |
	preProcessingParser := ('Libellule' asParser preProcessor: ('Y' asParser plus ==> [:p | ''])) preProcessor: ('T' asParser ==> [:p | '']).
	parser :=  'yoyo' asParser, preProcessingParser, 'yoyo' asParser.
	self assert: (parser matches: 'yoyoLiYYbTeYYlTluTlYYeyoyo').
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testMixingDataToPreProcessAndNot [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcessor: ('T' asParser ==> [:p | '']).
	self assert: (('DoNoTPreProcess' asParser, preProcessingParser, 'NotThisToo' asParser) matches: 'DoNoTPreProcessLibTelTluTleNotThisToo')
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testPreprocess [
	| preProcessor |
	preProcessor := PPrePParserStreamPreProcessor new.
	preProcessor matchingParser: ('T' asParser ==> [:p | '']).
	self assert: 'My String' equals: (preProcessor preProcess: 'MTy TStrTingT' asPetitStream ) contents 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testPreprocessWithPreviousContent [
	| aStream preProcessor |
	preProcessor := PPrePParserStreamPreProcessor new.
	preProcessor matchingParser: ('T' asParser ==> [:p | '']).
	self assert: 'My String' equals: (preProcessor preProcess: ('PreviousContentMTy TStrTingT' asPetitStream position: 15; yourself)) contents 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testRelativePositionForDoubleInclusion [
	|preProcessingParser token |	
	preProcessingParser := (('yoyo' asParser, ('Libellule' asParser info), 'yoyo' asParser) preProcessor: ('Y' asParser plus ==> [:p | ''])) preProcessor: ('T' asParser ==> [:p | '']).
	token := (preProcessingParser parse:  'yTYYoyTYYoLiYYbTeYYlTluTlYYeyToYYyTo') second.
	self assert: token start equals: 11.
	self assert: token stop equals: 28. 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testRelativePositionForIncludedParser [
	|preProcessingParser token |	
	preProcessingParser := (('yoyo' asParser, ('Libellule' asParser info), 'yoyo' asParser) preProcessor: ('Y' asParser plus ==> [:p | ''])) preProcessor: ('T' asParser ==> [:p | '']).
	token := (preProcessingParser parse:  'yToyToLibTelTluTleyToyTo') second.
	self assert: token start equals: 7.
	self assert: token stop equals: 18. 
]

{ #category : #'as yet unclassified' }
PPPreProcessingParserTest >> testWithPotentiallyPreprocessedDataAround [
	|preProcessingParser|	
	preProcessingParser := 'Libellule' asParser preProcessor: ('T' asParser ==> [:p | '']).
	self assert: (preProcessingParser end matches: 'TLibTelTluTleT')
]
