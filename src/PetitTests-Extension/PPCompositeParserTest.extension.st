Extension { #name : #PPCompositeParserTest }

{ #category : #'*PetitTests-Extension' }
PPCompositeParserTest >> failAndConsumeNothing: aString rule: aSymbol [
	| production |
	production := self parserInstanceFor: aSymbol.
	result := production parse: aString.
	self
		assert: result isPetitFailure.	
	^ result value
]

{ #category : #'*PetitTests-Extension' }
PPCompositeParserTest >> parse: aString rule: aSymbol shouldParse: aPartOfTheFirstString [
	"this test is when you want to add some context after the rules to test to ensure it will not parse more than expected"
	| production |
	production := self parserInstanceFor: aSymbol.
	result := production token parse: aString.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	self assert: (result size = aPartOfTheFirstString size) description: 'The parsing is different from expected: ', aPartOfTheFirstString printString, ' parsed: ', (aString first: result size).
	^ result value
]
