"
A PPExtendedCompositeParser offers you a new way to create rules. Just define your rule as a method in the #rules protocol and it will be managed exactly like rules in PPCompositeParser.
You will not have the limitation of 256 rules due to the instance variables limit but you will need to refer to your rule with the method #rule: in any other rule using it.

You can mix PPCompositeParser and PPExtendedCompositeParser way to define rules.

Look at PPExtendedCompositeParserFake to have a basic example.
"
Class {
	#name : #PPExtendedCompositeParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'dictionaryParser'
	],
	#category : #'PetitParser-Extension'
}

{ #category : #accessing }
PPExtendedCompositeParser class >> ignoredNames [
	^ super ignoredNames, #(#dictionaryParser)
]

{ #category : #initialization }
PPExtendedCompositeParser >> allExtendedRules [
	"default is to get all rules in a given protocol"
	^ (({self class}, self class allSuperclasses) select: [ :aClass | aClass inheritsFrom: PPExtendedCompositeParser  ])
flatCollect: [ :aClass | (aClass methodsInProtocol: self extendedRulesProtocol) collect: #selector ]
	
]

{ #category : #accessing }
PPExtendedCompositeParser >> dictionaryParser [
	^ dictionaryParser
]

{ #category : #accessing }
PPExtendedCompositeParser >> dictionaryParser: anObject [
	dictionaryParser := anObject
]

{ #category : #initialization }
PPExtendedCompositeParser >> extendedRulesProtocol [
	^ #rules
]

{ #category : #initialization }
PPExtendedCompositeParser >> initialize [
	dictionaryParser := Dictionary new.
	self allExtendedRules
		do: [ :aRuleSelector | self dictionaryParser at: aRuleSelector put: (PPDelegateParser named: aRuleSelector) ]
]

{ #category : #initialization }
PPExtendedCompositeParser >> initializeStartingAt: aSymbol dependencies: aDictionary [
	super initializeStartingAt: aSymbol dependencies: aDictionary.
	self dictionaryParser keysAndValuesDo: [ :aRuleSelector :aDelegateParser |
		aDelegateParser setParser: (self perform: aRuleSelector) ]
]

{ #category : #querying }
PPExtendedCompositeParser >> productionAt: aSymbol ifAbsent: aBlock [
	^ [ self rule: aSymbol ]
		on: NotFound
		do: [ super productionAt: aSymbol ifAbsent: aBlock ]
]

{ #category : #'as yet unclassified' }
PPExtendedCompositeParser >> rule: aRuleSymbol [
	^ self dictionaryParser at: aRuleSymbol
]
