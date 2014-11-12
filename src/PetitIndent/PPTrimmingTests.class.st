Class {
	#name : #PPTrimmingTests,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'result',
		'parser',
		'input',
		'context'
	],
	#category : #'PetitIndent-Tests'
}

{ #category : #'as yet unclassified' }
PPTrimmingTests >> assert: aParser parse: aCollection to: aTargetObject end: anInteger [
	^ result := super assert: aParser parse: aCollection to: aTargetObject end: anInteger
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> comment [
	^ '/*' asParser, '*/' asParser negate star, '*/' asParser
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> context [
	context ifNil: [ 
		context := super context.
	].
	^ context
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test01 [
	parser := 'a' asParser trimWithoutIndents, 'b' asParser trimWithoutIndents.

	self assert: parser parse: 'a   b '.
	self assert: result first = 'a'.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test02 [
	parser := 'a' asParser trimWithoutIndents, #indent asParser, 'b' asParser trimWithoutIndents.	
	input := 
'a 
	b '.
		
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test03 [
	parser := 'a' asParser trimWithoutIndents, 'b' asParser trimWithoutIndents.	
	input := 
'a
b '.

	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test04 [
	parser := 'a' asParser trimWithoutIndents, 'b' asParser trimWithoutIndents, 'c' asParser.	
	input := 
'a

b c'.

	self assert: parser parse: input.

]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test05 [
	parser := 'a' asParser trimWithoutIndents, 'b' asParser trimWithoutIndents, 'c' asParser.	
	input := 
'
a

b
	c'.
	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test06 [
	parser := 'a' asParser trimWithoutIndents, 'b' asParser trimWithoutIndents, #indent asParser, 
					'c' asParser.	
	input := 
'
a

b 
	c'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test07 [
	parser := 'a' asParser trimWithoutIndents, #indent asParser, 
					'b' asParser trimWithoutIndents, 
					'c' asParser.	
	input := 
'a
	b 
	c'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test08 [
	parser := 'a' asParser trimWithoutIndents, #indent asParser, 
					'b' asParser trimWithoutIndents, 
					'c' asParser trimWithoutIndents.	
	input := 
'a
	b 
	c'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> test09 [
	parser := 'a' asParser trimWithoutIndents, #indent asParser, 
		'b' asParser trimWithoutIndents, #indent asParser, 
			'c' asParser trimWithoutIndents.	
	
	input := 
'a
	b 
		c '.
		
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCodeLayout01 [
	self context globalAt: #comments put:  { self comment }.
	parser := #codeLayout asParser star, 'a' asParser.

	self assert: parser parse:  ' /* comment */ a'.
	self assert: result second = 'a'.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCodeLayout02 [
	self context globalAt: #comments put:  { self comment }.
	parser := 'a' asParser trimWithoutIndents.

	self assert: parser parse: 'a  /* comment */ '.
	self assert: result = 'a'.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCodeLayout03 [
	self context globalAt: #comments put:  { self comment }.
	parser := 'a' asParser trimWithIndents.

	self assert: parser parse: 'a  /* comment */ '.
	self assert: result = 'a'.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCodeLayout04 [
	self context globalAt: #comments put:  { self comment }.
	parser := 'a' asParser trimWithIndents.

	input := '
	/* abc */ 
	a  
	/* comment */ '.
	
	self assert: parser parse: input.
	self assert: result = 'a'.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCodeLayout05 [
	self context globalAt: #comments put:  { self comment }.
	parser := 'a' asParser trimWithoutIndents, 'b' asParser.

	input :=
'a  
  /* comment */ 
b'.
	self assert: parser parse: input.
	self assert: result first = 'a'.
	self assert: result second = 'b'.	
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCodeLayout06 [
	self context globalAt: #comments put:  { self comment }.
	parser := 'a' asParser trimWithoutIndents, 'b' asParser.

	input := 
'a  
  /* comment */ 
 b'.
	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCodeLayout07 [
	self context globalAt: #comments put:  { self comment }.
	parser := 'a' asParser, #indent asParser, 'b' asParser, #dedent asParser, 'c' asParser.

	input := 
'a
	b
/* comment */
c'.
	
	self assert: parser parse: input.
	self assert: result first = 'a'.
	self assert: result third = 'b'.
	self assert: result fifth = 'c'.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testComment [
	parser := self comment.

	self assert: parser parse: '/* hi there! */'.
	self assert: parser end fail: '/* hi there! */ '.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCut01 [
	parser := 'a' asParser cut, 'b' asParser.

	input := 'ab'.
	self assert: parser parse: input.
	
	input := 'a 		 b'.
	self assert: parser parse: input.
	
	input := ' 	a 		 b'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCut02 [
	parser := 'a' asParser cut, 'b' asParser.

	input := 'a
	b'.
	self assert: parser parse: input.
	
	input := 'a 	
			 b'.
	self assert: parser parse: input.
	
	input := ' 	
		a 		 
				b'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCut03 [
	parser := 'a' asParser cut, #indent asParser, 'b' asParser.

	input := 
'a
	b'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCut04 [
	parser := 'a' asParser cut, #indent asParser, 'b' asParser cut, #dedent asParser.

	input := 
'a 
	b 
'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testCut05 [
	parser := 'a' asParser cut, ((#indent asParser, 'b' asParser cut) / 'c' asParser).

	input := 
'a 
	b'.
	self assert: parser parse: input.
	
	input := 
'a 
	c'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents01 [
	parser := 'a' asParser trimWithIndents, 'b' asParser, #dedent asParser.
	input := 
'a
	b
'.

	self assert: parser parse: input.
	self assert: result first = 'a'.
	self assert: result second = 'b'.
	self assert: result third = #dedent.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents02 [
	parser := 'a' asParser trimWithIndents, 'b' asParser, #dedent asParser.
	input := 
'a
	b'.

	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents03 [
	parser := 'a' asParser trimWithIndents, 'b' asParser, #dedent asParser.
	input := 
'a
		b'.

	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents04 [
	parser := 'a' asParser trimWithIndents, 'b' asParser, #dedent asParser.
	input := 
'a
		b
'.

	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents05 [
	parser := 'a' asParser trimWithIndents, 'b' asParser trimWithIndents.
	input := 
'a
		b
'.

	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents06 [
	parser := 'a' asParser trimWithIndents, 'b' asParser trimWithIndents, #indent asParser, 
		'c' asParser.
	input := 
'a
	b
'.

	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents07 [
	parser := 'a' asParser trimWithIndents, 'b' asParser trimWithIndents, 'c' asParser, #indent asParser, 'd' asParser.
	input := 
'a
	b

c
	d'.

	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPTrimmingTests >> testTrimWithIndents08 [
	parser := 'a' asParser trimWithIndents, 'b' asParser, #dedent asParser, #dedent asParser.
	input := 
'
	a
		b
'.

	self assert: parser parse: input.
]
