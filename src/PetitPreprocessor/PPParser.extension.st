Extension { #name : #PPParser }

{ #category : #'*PetitPreprocessor' }
PPParser >> chainPreProcessors: preprocList [
	"Applies a list of pre processors (in the given order) on the receiver"

	 ^  (preprocList inject: self into: [:accuParser :preproc | accuParser preProcessor: preproc])
]

{ #category : #'*PetitPreprocessor' }
PPParser >> info [
	"Answer a new parser that transforms the input to an info object, containing evaluation and positions."
	
	^ PPInfoParser on: self
]

{ #category : #'*PetitPreprocessor' }
PPParser >> preProcess: aRegex into: aReplacement [
	^ PPreRegexStreamPreProcessor new setParser: self; regex: aRegex; replacement: aReplacement; yourself
]

{ #category : #'*PetitPreprocessor' }
PPParser >> preProcessor: aPParserWithEvaluationBlock [
	^ PPrePParserStreamPreProcessor new setParser: self; matchingParser: aPParserWithEvaluationBlock; yourself
]
