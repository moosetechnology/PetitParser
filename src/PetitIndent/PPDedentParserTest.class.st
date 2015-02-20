Class {
	#name : #PPDedentParserTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'indentationLevel',
		'indent',
		'dedent',
		'input',
		'parser'
	],
	#category : #'PetitIndent-Tests'
}

{ #category : #'as yet unclassified' }
PPDedentParserTest >> assert: aParser parse: aCollection to: aTargetObject end: anInteger [
	^ result := super assert: aParser parse: aCollection to: aTargetObject end: anInteger
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> setUp [
	super setUp.
	indentationLevel := PPIndentationLevel instance.
	indent := #indent asParser.
	dedent := #dedent asParser.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> suiteParser [
	| suite stmt |
	
	suite := PPDelegateParser new name: 'suite'; yourself.
	stmt := 'lorem' asParser name: 'stmt'; yourself.
	suite setParser: indent, (stmt / suite) trimWithoutIndents plus, dedent.
	^ suite end
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testDedent [
	parser  := 	'lorem' asParser, indent, 
						'ipsum' asParser, dedent, 
					'dolor' asParser .
	input := 
'lorem
	ipsum
dolor'	.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testDedent2 [
	parser := 	'lorem' asParser, indent, 
						'ipsum' asParser,  
					dedent, 'dolor' asParser.

	input :=
'lorem
		ipsum
	dolor'.
	
	self assert: parser fail: input.

]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testDedent3 [
	parser  := 	'lorem' asParser, indent, 
						'ipsum' asParser, dedent, 
					'dolor' asParser.

	input := 
'lorem
		ipsum
dolor'.

	self assert: parser parse: input.

]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testDedent4 [
	parser  := 'lorem' asParser, indent, 
					'ipsum' asParser, indent,
						'dolor' asParser, dedent,
					'sit' asParser.

	input := 
'lorem
	ipsum
		dolor
	sit'.
		
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testDedentTrim1 [
	parser  :=  'lorem' asParser, indent, 
						('ipsum' asParser) trimWithoutIndents star, dedent, 
					'dolor' asParser.
	
	input := 
'lorem
		ipsum
		ipsum
dolor'.	
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testDedentTrim2 [
	parser  := 	'lorem' asParser, indent, 
						'ipsum' asParser trimWithoutIndents star, dedent,
					'dolor' asParser.

	input := 
'lorem
		ipsum
		 ipsum
dolor'.	
	
	self assert: parser fail: input

]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite01 [
	parser  := self suiteParser.
	input := 
'
  lorem
  lorem
'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite02 [
	|   |
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
        lorem
    lorem
'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite03 [
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
        lorem
lorem
'.
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite03_1 [
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
        lorem
   lorem
'.
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite03_2 [
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
        lorem
     lorem
'.

	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite04 [
	parser  := self suiteParser.
	input := 	
'
    lorem
        lorem
            lorem
    lorem
'.

	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite05 [
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
            lorem
        lorem
'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite07 [
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
            lorem
   lorem
'.
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite08 [
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
            lorem
     lorem
'.
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite09 [
	parser  := self suiteParser.
	input := 	
'
    lorem
        lorem
            lorem
       lorem
'.
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPDedentParserTest >> testSuite10 [
	parser  := self suiteParser.
	input := 
'
    lorem
        lorem
            lorem
         lorem
'.

	self assert: parser fail: input.
]
