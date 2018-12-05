Class {
	#name : #PPInfoParserTest,
	#superclass : #TestCase,
	#category : 'PetitPreprocessor-Tests'
}

{ #category : #'as yet unclassified' }
PPInfoParserTest >> testBasicInfo [
	| nodes infos |
	nodes:= ('Lorem ipsum ' asParser, ('dolor' asParser token info),' sit amet' asParser) parse: 'Lorem ipsum dolor sit amet'.
	infos:= nodes second.
	self assert: infos start equals: 13.
	self assert: infos stop equals: 17.
	self assert: infos element start equals: infos start.
	self assert: infos element stop equals: infos stop.
]

{ #category : #'as yet unclassified' }
PPInfoParserTest >> testPreProcessedStreamInfo [
	| nodes infos |
	nodes:= (('Lorem ipsum ' asParser, ('dolor' asParser token info),' sit amet' asParser) preProcess: '\[Sp\]' asRegex into: ' ') parse: 'Lorem[Sp]ipsum[Sp]dolor[Sp]sit[Sp]amet'.
	infos:= nodes second.
	self assert: infos start equals: 19.
	self assert: infos stop equals: 23.
]
