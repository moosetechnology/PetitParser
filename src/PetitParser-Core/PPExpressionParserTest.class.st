Class {
	#name : #PPExpressionParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitParser-Tests'
}

{ #category : #accessing }
PPExpressionParserTest >> parseClass [
	^ PPExpressionParser
]

{ #category : #testing }
PPExpressionParserTest >> testAdd [
	self assert: '1 + 2' is: 3.
	self assert: '2 + 1' is: 3.
	self assert: '1 + 2.3' is: 3.3.
	self assert: '2.3 + 1' is: 3.3.
	self assert: '1 + -2' is: -1.
	self assert: '-2 + 1' is: -1
]

{ #category : #testing }
PPExpressionParserTest >> testAddMany [
	self assert: '1' is: 1.
	self assert: '1 + 2' is: 3.
	self assert: '1 + 2 + 3' is: 6.
	self assert: '1 + 2 + 3 + 4' is: 10.
	self assert: '1 + 2 + 3 + 4 + 5' is: 15
]

{ #category : #'testing-expression' }
PPExpressionParserTest >> testBrackets [
	self assert: '(1)' is: 1.
	self assert: '(1 + 2)' is: 3.
	
	self assert: '((1))' is: 1.
	self assert: '((1 + 2))' is: 3.

	self assert: '2 * (3 + 4)' is: 14.
	self assert: '(2 + 3) * 4' is: 20.
	self assert: '6 / (2 + 4)' is: 1.
	self assert: '(2 + 6) / 2' is: 4
]

{ #category : #testing }
PPExpressionParserTest >> testDiv [
	self assert: '12 / 3' is: 4.
	self assert: '-16 / -4' is: 4
]

{ #category : #testing }
PPExpressionParserTest >> testMul [
	self assert: '2 * 3' is: 6.
	self assert: '2 * -4' is: -8
]

{ #category : #testing }
PPExpressionParserTest >> testMulMany [
	self assert: '1 * 2' is: 2.
	self assert: '1 * 2 * 3' is: 6.
	self assert: '1 * 2 * 3 * 4' is: 24.
	self assert: '1 * 2 * 3 * 4 * 5' is: 120
]

{ #category : #testing }
PPExpressionParserTest >> testNum [
	self assert: '0' is: 0.
	self assert: '0.0' is: 0.0.
	self assert: '1' is: 1.
	self assert: '1.2' is: 1.2.
	self assert: '34' is: 34.
	self assert: '56.78' is: 56.78.
	self assert: '-9' is: -9.
	self assert: '-9.9' is: -9.9
]

{ #category : #'testing-expression' }
PPExpressionParserTest >> testPriority [
	self assert: '2 * 3 + 4' is: 10.
	self assert: '2 + 3 * 4' is: 14.
	self assert: '6 / 3 + 4' is: 6.
	self assert: '2 + 6 / 2' is: 5
]

{ #category : #testing }
PPExpressionParserTest >> testSub [
	self assert: '1 - 2' is: -1.
	self assert: '1.3 - 2' is: -0.7.
	self assert: '1 - -2' is: 3
]
