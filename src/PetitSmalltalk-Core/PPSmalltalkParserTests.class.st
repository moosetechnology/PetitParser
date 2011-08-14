Class {
	#name : #PPSmalltalkParserTests,
	#superclass : #PPSmalltalkGrammarTests,
	#category : #'PetitSmalltalk-Tests'
}

{ #category : #private }
PPSmalltalkParserTests >> assert: aNode format: aString [ 
	aNode isCollection 
		ifFalse: [ ^ self assert: (Array with: aNode) format: (Array with: aString) ].
	self assert: aNode size = aString size.
	aNode
		with: aString
		do: [ :node :string | self assert: (RBFormatter new format: node) withBlanksTrimmed = string ]
]

{ #category : #accessing }
PPSmalltalkParserTests >> parserClass [
	^ PPSmalltalkParser
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testArgumentsBlock1 [
	super testArgumentsBlock1.
	self assert: result isBlock.
	self assert: result arguments size = 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testArgumentsBlock2 [
	super testArgumentsBlock2.
	self assert: result isBlock.
	self assert: result arguments size = 2.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name = 'b'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testArgumentsBlock3 [
	super testArgumentsBlock3.
	self assert: result isBlock.
	self assert: result arguments size = 3.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name = 'b'.
	self assert: result arguments third isVariable.
	self assert: result arguments third name = 'c'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #testing }
PPSmalltalkParserTests >> testArray1 [
	super testArray1.
	self assert: result isArray.
	self assert: result statements isEmpty.
	self assert: result periods isEmpty
]

{ #category : #testing }
PPSmalltalkParserTests >> testArray2 [
	super testArray2.
	self assert: result isArray.
	self assert: result periods isEmpty.
	self assert: result statements size = 1.
	self assert: result statements first isMessage.
	self assert: result statements first selector = #foo
]

{ #category : #testing }
PPSmalltalkParserTests >> testArray3 [
	super testArray3.
	self assert: result isArray.
	self assert: result periods size = 1.
	self assert: result statements size = 2.
	self assert: result statements first isMessage.
	self assert: result statements first selector = #foo.
	self assert: result statements last isMessage.
	self assert: result statements last selector = #bar
]

{ #category : #testing }
PPSmalltalkParserTests >> testArray4 [
	super testArray4.
	self assert: result isArray.
	self assert: result periods size = 2.
	self assert: result statements size = 2.
	self assert: result statements first isMessage.
	self assert: result statements first selector = #foo.
	self assert: result statements last isMessage.
	self assert: result statements last selector = #bar
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral1 [
	super testArrayLiteral1.
	self assert: result isLiteral.
	self assert: result value = #()
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral10 [
	super testArrayLiteral10.
	self assert: result isLiteral.
	self assert: result value = #(#(1 2 ) #(1 2 3 ) )
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral11 [
	super testArrayLiteral11.
	self assert: result isLiteral.
	self assert: result value size = 2.
	self assert: (result value first isKindOf: ByteArray).
	self assert: result value first size = 2.
	self assert: (result value last isKindOf: ByteArray).
	self assert: result value last size = 3
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral2 [
	super testArrayLiteral2.
	self assert: result isLiteral.
	self assert: result value = #(1)
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral3 [
	super testArrayLiteral3.
	self assert: result isLiteral.
	self assert: result value = #(1 2 )
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral4 [
	super testArrayLiteral4.
	self assert: result isLiteral.
	self assert: result value = #(true false nil )
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral5 [
	super testArrayLiteral5.
	self assert: result isLiteral.
	self assert: result value = #($a )
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral6 [
	super testArrayLiteral6.
	self assert: result isLiteral.
	self assert: result value = #(1.2 )
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral7 [
	super testArrayLiteral7.
	self assert: result isLiteral.
	self assert: result value = #(#size #at: #at:put: #'==' ).
	result value do: [ :each | self assert: each isSymbol ]
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral8 [
	super testArrayLiteral8.
	self assert: result isLiteral.
	self assert: result value = #('baz' ).
	self assert: result value first isString.
	self assert: result value first isSymbol not
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testArrayLiteral9 [
	super testArrayLiteral9.
	self assert: result isLiteral.
	self assert: result value = #(#(1 ) 2 )
]

{ #category : #testing }
PPSmalltalkParserTests >> testAssignment1 [
	super testAssignment1.
	self assert: result isLiteral.
	self assert: result value = 1
]

{ #category : #testing }
PPSmalltalkParserTests >> testAssignment2 [
	super testAssignment2.
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name = 'a'.
	self assert: result value isLiteral.
	self assert: result value value = 1
]

{ #category : #testing }
PPSmalltalkParserTests >> testAssignment3 [
	super testAssignment3.
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name = 'a'.
	self assert: result value isAssignment.
	self assert: result value variable isVariable.
	self assert: result value variable name = 'b'.
	self assert: result value value isLiteral.
	self assert: result value value value = 1
]

{ #category : #testing }
PPSmalltalkParserTests >> testAssignment4 [
	super testAssignment4.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifFalse: [ ^ self ].
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name = 'a'.
	self assert: result value isLiteral.
	self assert: result value value = 1
]

{ #category : #testing }
PPSmalltalkParserTests >> testAssignment5 [
	super testAssignment5.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifFalse: [ ^ self ].
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name = 'a'.
	self assert: result value isAssignment.
	self assert: result value variable isVariable.
	self assert: result value variable name = 'b'.
	self assert: result value value isLiteral.
	self assert: result value value value = 1
]

{ #category : #testing }
PPSmalltalkParserTests >> testAssignment6 [
	super testAssignment6.
	self assert: result isAssignment.
	self assert: result variable isVariable.
	self assert: result variable name = 'a'.
	self assert: result value isAssignment.
	self assert: result value variable isVariable.
	self assert: result value variable name = 'b'.
	self assert: result value value isVariable.
	self assert: result value value name = 'c'
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryExpression1 [
	super testBinaryExpression1.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result receiver value = 1.
	self assert: result arguments size = 1.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 2
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryExpression2 [
	super testBinaryExpression2.
	self assert: result isMessage.
	self assert: result receiver isMessage.
	self assert: result receiver receiver isLiteral.
	self assert: result receiver receiver value = 1.
	self assert: result receiver arguments size = 1.
	self assert: result receiver arguments first isLiteral.
	self assert: result receiver arguments first value = 2.
	self assert: result arguments size = 1.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 3
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryExpression3 [
	super testBinaryExpression3.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result receiver value = 1.
	self assert: result selector = #//.
	self assert: result arguments size = 1.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 2
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryExpression4 [
	super testBinaryExpression4.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result receiver value = 1.
	self assert: result selector = #--.
	self assert: result arguments size = 1.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 2
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryExpression5 [
	super testBinaryExpression5.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result receiver value = 1.
	self assert: result selector = #==>.
	self assert: result arguments size = 1.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 2
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryMethod1 [
	super testBinaryMethod1.
	self assert: result isMethod.
	self assert: result selector = #+.
	self assert: result arguments size = 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryMethod2 [
	super testBinaryMethod2.
	self assert: result isMethod.
	self assert: result selector = #+.
	self assert: result arguments size = 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result body temporaries size = 1.
	self assert: result body statements isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryMethod3 [
	super testBinaryMethod3.
	self assert: result isMethod.
	self assert: result selector = #+.
	self assert: result arguments size = 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryMethod4 [
	super testBinaryMethod4.
	self assert: result isMethod.
	self assert: result selector = #+.
	self assert: result arguments size = 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result body temporaries size = 1.
	self assert: result body statements size = 1
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testBinaryMethod5 [
	super testBinaryMethod5.
	self assert: result isMethod.
	self assert: result selector = #--.
	self assert: result arguments size = 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testByteLiteral1 [
	super testByteLiteral1.
	self assert: result isLiteral.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value isEmpty
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testByteLiteral2 [
	super testByteLiteral2.
	self assert: result isLiteral.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size = 1.
	self assert: result value first = 0
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testByteLiteral3 [
	super testByteLiteral3.
	self assert: result isLiteral.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size = 1.
	self assert: result value first = 255
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testByteLiteral4 [
	super testByteLiteral4.
	self assert: result isLiteral.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size = 2.
	self assert: result value first = 1.
	self assert: result value last = 2
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testByteLiteral5 [
	super testByteLiteral5.
	self assert: result isLiteral.
	self assert: (result value isKindOf: ByteArray).
	self assert: result value size = 3.
	self assert: result value first = 10.
	self assert: result value second = 63.
	self assert: result value last = 255
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testCascadeExpression1 [
	super testCascadeExpression1.
	self assert: result isCascade.
	self assert: result receiver isLiteral.
	self assert: result messages size = 2.
	self assert: result messages first receiver = result receiver.
	self assert: result messages first selector = #abs.
	self assert: result messages second receiver = result receiver.
	self assert: result messages second selector = #negated
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testCascadeExpression2 [
	super testCascadeExpression2.
	self assert: result isCascade.
	self assert: result receiver isMessage.
	self assert: result receiver receiver isLiteral.
	self assert: result receiver receiver value = 1.
	self assert: result receiver selector = #abs.
	self assert: result messages size = 3.
	self assert: result messages first receiver = result receiver.
	self assert: result messages first selector = #negated.
	self assert: result messages second receiver = result receiver.
	self assert: result messages second selector = #raisedTo:.
	self assert: result messages third receiver = result receiver.
	self assert: result messages third selector = #negated
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testCascadeExpression3 [
	super testCascadeExpression3.
	self assert: result isCascade.
	self assert: result receiver isLiteral.
	self assert: result receiver value = 1.
	self assert: result messages size = 2.
	self assert: result messages first receiver = result receiver.
	self assert: result messages first selector = #+.
	self assert: result messages first arguments size = 1.
	self assert: result messages second receiver = result receiver.
	self assert: result messages second selector = #-.
	self assert: result messages second arguments size = 1
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testCharLiteral1 [
	super testCharLiteral1.
	self assert: result isLiteral.
	self assert: result value = $a
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testCharLiteral2 [
	super testCharLiteral2.
	self assert: result isLiteral.
	self assert: result value = Character space
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testCharLiteral3 [
	super testCharLiteral3.
	self assert: result isLiteral.
	self assert: result value = $$
]

{ #category : #testing }
PPSmalltalkParserTests >> testComment1 [
	super testComment1.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector = #+.
	self assert: result arguments first isValue
]

{ #category : #testing }
PPSmalltalkParserTests >> testComment2 [
	super testComment2.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector = #+.
	self assert: result arguments first isValue
]

{ #category : #testing }
PPSmalltalkParserTests >> testComment3 [
	super testComment3.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector = #+.
	self assert: result arguments first isValue
]

{ #category : #testing }
PPSmalltalkParserTests >> testComment4 [
	super testComment4.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector = #+.
	self assert: result arguments first isValue
]

{ #category : #testing }
PPSmalltalkParserTests >> testComment5 [
	super testComment5.
	self assert: result isMessage.
	self assert: result receiver isValue.
	self assert: result selector = #+.
	self assert: result arguments first isValue
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testComplexBlock1 [
	super testComplexBlock1.
	self assert: result isBlock.
	self assert: result arguments size = 1.
	self assert: result body temporaries size = 1.
	self assert: result body statements size = 1
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testComplexBlock2 [
	super testComplexBlock2.
	self assert: result isBlock.
	self assert: result arguments size = 1.
	self assert: result body temporaries size = 1.
	self assert: result body statements size = 1
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testKeywordExpression1 [
	super testKeywordExpression1.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result receiver value = 1.
	self assert: result selector = #to:.
	self assert: result arguments size = 1.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 2
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testKeywordExpression2 [
	super testKeywordExpression2.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result selector = #to:by:.
	self assert: result arguments size = 2.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 2.
	self assert: result arguments second isLiteral.
	self assert: result arguments second value = 3
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testKeywordExpression3 [
	super testKeywordExpression3.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result selector = #to:by:do:.
	self assert: result arguments size = 3.
	self assert: result arguments first isLiteral.
	self assert: result arguments first value = 2.
	self assert: result arguments second isLiteral.
	self assert: result arguments second value = 3.
	self assert: result arguments third isLiteral.
	self assert: result arguments third value = 4
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testKeywordMethod1 [
	super testKeywordMethod1.
	self assert: result isMethod.
	self assert: result selector = #to:.
	self assert: result arguments size = 1.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testKeywordMethod2 [
	super testKeywordMethod2.
	self assert: result isMethod.
	self assert: result selector = #to:do:.
	self assert: result arguments size = 2.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name = 'b'.
	self assert: result body temporaries size = 1.
	self assert: result body statements isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testKeywordMethod3 [
	super testKeywordMethod3.
	self assert: result isMethod.
	self assert: result selector = #to:do:by:.
	self assert: result arguments size = 3.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name = 'b'.
	self assert: result arguments third isVariable.
	self assert: result arguments third name = 'c'.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testKeywordMethod4 [
	super testKeywordMethod4.
	self assert: result isMethod.
	self assert: result selector = #to:do:by:.
	self assert: result arguments size = 3.
	self assert: result arguments first isVariable.
	self assert: result arguments first name = 'a'.
	self assert: result arguments second isVariable.
	self assert: result arguments second name = 'b'.
	self assert: result arguments third isVariable.
	self assert: result arguments third name = 'c'.
	self assert: result body temporaries size = 1.
	self assert: result body statements size = 1
]

{ #category : #testing }
PPSmalltalkParserTests >> testMethod1 [
	super testMethod1.
	self assert: result isMethod.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1.
	self assert: result body statements first isReturn.
	self assert: result body statements first value isMessage.
	self assert: result body statements first value receiver isLiteral.
	self assert: result body statements first value selector = #-.
	self assert: result body statements first value arguments size = 1.
	self assert: result body statements first value arguments first isVariable
]

{ #category : #testing }
PPSmalltalkParserTests >> testMethod2 [
	super testMethod2.
	self assert: result isMethod.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1.
	self assert: result body statements first isReturn.
	self assert: result body statements first value isMessage.
	self assert: result body statements first value receiver isLiteral.
	self assert: result body statements first value selector = #-.
	self assert: result body statements first value arguments size = 1.
	self assert: result body statements first value arguments first isVariable
]

{ #category : #testing }
PPSmalltalkParserTests >> testMethod3 [
	super testMethod3.
	self assert: result isMethod.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1.
	self assert: result body statements first isReturn.
	self assert: result body statements first value isMessage.
	self assert: result body statements first value receiver isLiteral.
	self assert: result body statements first value selector = #-.
	self assert: result body statements first value arguments size = 1.
	self assert: result body statements first value arguments first isVariable
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral1 [
	super testNumberLiteral1.
	self assert: result isLiteral.
	self assert: result value = 0.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral10 [
	super testNumberLiteral10.
	self assert: result isLiteral.
	self assert: result value = 10.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral11 [
	super testNumberLiteral11.
	self assert: result isLiteral.
	self assert: result value = 511.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral12 [
	super testNumberLiteral12.
	self assert: result isLiteral.
	self assert: result value = 175.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral13 [
	super testNumberLiteral13.
	self assert: result isLiteral.
	self assert: result value = 202.9921875.
	self assert: result value isFloat
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral14 [
	super testNumberLiteral14.
	self assert: result isLiteral.
	self assert: result value floor = -9.
	self assert: result value isFloat
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral15 [
	super testNumberLiteral15.
	self assert: result isLiteral.
	self assert: result value = (1 / 2)
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral2 [
	super testNumberLiteral2.
	self assert: result isLiteral.
	self assert: result value = 0.1.
	self assert: result value isFloat
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral3 [
	super testNumberLiteral3.
	self assert: result isLiteral.
	self assert: result value = 123.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral4 [
	super testNumberLiteral4.
	self assert: result isLiteral.
	self assert: result value = 123.456.
	self assert: result value isFloat
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral5 [
	super testNumberLiteral5.
	self assert: result isLiteral.
	self assert: result value = 0.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral6 [
	super testNumberLiteral6.
	self assert: result isLiteral.
	self assert: result value = -0.1.
	self assert: result value isFloat
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral7 [
	super testNumberLiteral7.
	self assert: result isLiteral.
	self assert: result value = -123.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral8 [
	super testNumberLiteral8.
	self assert: result isLiteral.
	self assert: result value = -123.
	self assert: result value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testNumberLiteral9 [
	super testNumberLiteral9.
	self assert: result isLiteral.
	self assert: result value = -123.456.
	self assert: result value isFloat
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma1 [
	super testPragma1.
	self 
		assert: result pragmas
		format: #('<foo>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma10 [
	super testPragma10.
	self 
		assert: result pragmas
		format: #('<foo: #bar>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma11 [
	super testPragma11.
	self 
		assert: result pragmas
		format: #('<foo: true>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma12 [
	super testPragma12.
	self 
		assert: result pragmas
		format: #('<foo: false>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma13 [
	super testPragma13.
	self 
		assert: result pragmas
		format: #('<foo: nil>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma14 [
	super testPragma14.
	self 
		assert: result pragmas
		format: #('<foo: #()>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma15 [
	super testPragma15.
	self 
		assert: result pragmas
		format: #('<foo: #()>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma16 [
	super testPragma16.
	self 
		assert: result pragmas
		format: #('< + 1>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma2 [
	super testPragma2.
	self 
		assert: result pragmas
		format: #('<foo>' '<bar>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma3 [
	super testPragma3.
	self 
		assert: result pragmas
		format: #('<foo>' ).
	self assert: result body temporaries size = 1.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma4 [
	super testPragma4.
	self 
		assert: result pragmas
		format: #('<foo>' ).
	self assert: result body temporaries size = 1.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma5 [
	super testPragma5.
	self 
		assert: result pragmas
		format: #('<foo>' '<bar>' ).
	self assert: result body temporaries size = 1.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma6 [
	super testPragma6.
	self 
		assert: result pragmas
		format: #('<foo: 1>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma7 [
	super testPragma7.
	self 
		assert: result pragmas
		format: #('<foo: 1.2>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma8 [
	super testPragma8.
	self 
		assert: result pragmas
		format: #('<foo: ''bar''>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-pragmas' }
PPSmalltalkParserTests >> testPragma9 [
	super testPragma9.
	self 
		assert: result pragmas
		format: #('<foo: #bar>' ).
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #testing }
PPSmalltalkParserTests >> testSequence1 [
	super testSequence1.
	self assert: result isSequence.
	self assert: result temporaries size = 1.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name = 'a'.
	self assert: result statements size = 2.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements second isLiteral.
	self assert: result statements second value = 2
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testSimpleBlock1 [
	super testSimpleBlock1.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testSimpleBlock2 [
	super testSimpleBlock2.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testSimpleBlock3 [
	super testSimpleBlock3.
	self assert: result isBlock.
	self assert: result arguments size = 1.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSpecialLiteral1 [
	super testSpecialLiteral1.
	self assert: result isLiteral.
	self assert: result value = true
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSpecialLiteral2 [
	super testSpecialLiteral2.
	self assert: result isLiteral.
	self assert: result value = false
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSpecialLiteral3 [
	super testSpecialLiteral3.
	self assert: result isLiteral.
	self assert: result value = nil
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testStatementBlock1 [
	super testStatementBlock1.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testStatementBlock2 [
	super testStatementBlock2.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size = 1.
	self assert: result body statements size = 1
]

{ #category : #'testing-blocks' }
PPSmalltalkParserTests >> testStatementBlock3 [
	super testStatementBlock3.
	self assert: result isBlock.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size = 2.
	self assert: result body statements size = 1
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements1 [
	super testStatements1.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 1.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements2 [
	super testStatements2.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 2.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteral.
	self assert: result statements second value = 2.
	self assert: result statements second value isInteger
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements3 [
	super testStatements3.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 3.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteral.
	self assert: result statements second value = 2.
	self assert: result statements second value isInteger.
	self assert: result statements third isLiteral.
	self assert: result statements third value = 3.
	self assert: result statements third value isInteger
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements4 [
	super testStatements4.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 3.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteral.
	self assert: result statements second value = 2.
	self assert: result statements second value isInteger.
	self assert: result statements third isLiteral.
	self assert: result statements third value = 3.
	self assert: result statements third value isInteger
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements5 [
	super testStatements5.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 2.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteral.
	self assert: result statements second value = 2.
	self assert: result statements second value isInteger
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements6 [
	super testStatements6.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 2.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger.
	self assert: result statements second isLiteral.
	self assert: result statements second value = 2.
	self assert: result statements second value isInteger
	
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements7 [
	super testStatements7.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 1.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger
]

{ #category : #testing }
PPSmalltalkParserTests >> testStatements8 [
	super testStatements8.
	self assert: result isSequence.
	self assert: result temporaries isEmpty.
	self assert: result statements size = 1.
	self assert: result statements first isLiteral.
	self assert: result statements first value = 1.
	self assert: result statements first value isInteger
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testStringLiteral1 [
	super testStringLiteral1.
	self assert: result isLiteral.
	self assert: result value = ''
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testStringLiteral2 [
	super testStringLiteral2.
	self assert: result isLiteral.
	self assert: result value = 'ab'
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testStringLiteral3 [
	super testStringLiteral3.
	self assert: result isLiteral.
	self assert: result value = 'ab''cd'
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral1 [
	super testSymbolLiteral1.
	self assert: result isLiteral.
	self assert: result value = #foo.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral2 [
	super testSymbolLiteral2.
	self assert: result isLiteral.
	self assert: result value = #+.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral3 [
	super testSymbolLiteral3.
	self assert: result isLiteral.
	self assert: result value = #key:.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral4 [
	super testSymbolLiteral4.
	self assert: result isLiteral.
	self assert: result value = #key:value:.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral5 [
	super testSymbolLiteral5.
	self assert: result isLiteral.
	self assert: result value = #'testing-result'.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral6 [
	super testSymbolLiteral6.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ ^ self ].
	self assert: result isLiteral.
	self assert: result value = #__gen__binding.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral7 [
	super testSymbolLiteral7.
	self assert: result isLiteral.
	self assert: result value = #fucker.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral8 [
	super testSymbolLiteral8.
	self assert: result isLiteral.
	self assert: result value = #fucker.
	self assert: result value isSymbol
]

{ #category : #'testing-literals' }
PPSmalltalkParserTests >> testSymbolLiteral9 [
	super testSymbolLiteral9.
	self assert: result isLiteral.
	self assert: result value = #fucker.
	self assert: result value isSymbol
]

{ #category : #testing }
PPSmalltalkParserTests >> testTemporaries1 [
	super testTemporaries1.
	self assert: result isSequence.
	self assert: result temporaries size = 1.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name = 'a'.
	self assert: result statements isEmpty
]

{ #category : #testing }
PPSmalltalkParserTests >> testTemporaries2 [
	super testTemporaries2.
	self assert: result isSequence.
	self assert: result temporaries size = 2.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name = 'a'.
	self assert: result temporaries second isVariable.
	self assert: result temporaries second name = 'b'.
	self assert: result statements isEmpty
]

{ #category : #testing }
PPSmalltalkParserTests >> testTemporaries3 [
	super testTemporaries3.
	self assert: result isSequence.
	self assert: result temporaries size = 3.
	self assert: result temporaries first isVariable.
	self assert: result temporaries first name = 'a'.
	self assert: result temporaries second isVariable.
	self assert: result temporaries second name = 'b'.
	self assert: result temporaries third isVariable.
	self assert: result temporaries third name = 'c'.
	self assert: result statements isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testUnaryExpression1 [
	super testUnaryExpression1.
	self assert: result isMessage.
	self assert: result receiver isLiteral.
	self assert: result selector = #abs.
	self assert: result arguments isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testUnaryExpression2 [
	super testUnaryExpression2.
	self assert: result isMessage.
	self assert: result receiver isMessage.
	self assert: result receiver receiver isLiteral.
	self assert: result receiver receiver value = 1.
	self assert: result receiver selector = #abs.
	self assert: result receiver arguments isEmpty.
	self assert: result selector = #negated.
	self assert: result arguments isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testUnaryMethod1 [
	super testUnaryMethod1.
	self assert: result isMethod.
	self assert: result selector = #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testUnaryMethod2 [
	super testUnaryMethod2.
	self assert: result isMethod.
	self assert: result selector = #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size = 1.
	self assert: result body statements isEmpty
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testUnaryMethod3 [
	super testUnaryMethod3.
	self assert: result isMethod.
	self assert: result selector = #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries isEmpty.
	self assert: result body statements size = 1
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testUnaryMethod4 [
	super testUnaryMethod4.
	self assert: result isMethod.
	self assert: result selector = #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size = 1.
	self assert: result body statements size = 1
]

{ #category : #'testing-messages' }
PPSmalltalkParserTests >> testUnaryMethod5 [
	super testUnaryMethod5.
	self assert: result isMethod.
	self assert: result selector = #abs.
	self assert: result arguments isEmpty.
	self assert: result body temporaries size = 1.
	self assert: result body statements isEmpty
]

{ #category : #testing }
PPSmalltalkParserTests >> testVariable1 [
	super testVariable1.
	self assert: result isVariable.
	self assert: result name = 'trueBinding'
]

{ #category : #testing }
PPSmalltalkParserTests >> testVariable2 [
	super testVariable2.
	self assert: result isVariable.
	self assert: result name = 'falseBinding'
]

{ #category : #testing }
PPSmalltalkParserTests >> testVariable3 [
	super testVariable3.
	self assert: result isVariable.
	self assert: result name = 'nilly'
]

{ #category : #testing }
PPSmalltalkParserTests >> testVariable4 [
	super testVariable4.
	self assert: result isVariable.
	self assert: result name = 'selfish'
]

{ #category : #testing }
PPSmalltalkParserTests >> testVariable5 [
	super testVariable5.
	self assert: result isVariable.
	self assert: result name = 'supernanny'
]

{ #category : #testing }
PPSmalltalkParserTests >> testVariable6 [
	super testVariable6.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ ^ self ].
	self assert: result isVariable.
	self assert: result name = 'super_nanny'
]

{ #category : #testing }
PPSmalltalkParserTests >> testVariable7 [
	super testVariable7.
	PPSmalltalkGrammar allowUnderscoreAssignment
		ifTrue: [ ^ self ].
	self assert: result isVariable.
	self assert: result name = '__gen_var_123__'
]
