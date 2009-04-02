Class {
	#name : #PPExamplesTest,
	#superclass : #PPAbstractParseTest,
	#category : #'PetitParser-Tests'
}

{ #category : #parsers }
PPExamplesTest >> comment [
	^ ($" asParser , $" asParser negate star , $" asParser) flatten
]

{ #category : #parsers }
PPExamplesTest >> identifier [
	^ (#letter asParser , #word asParser star) flatten
]

{ #category : #parsers }
PPExamplesTest >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten
]

{ #category : #testing }
PPExamplesTest >> testComment [
	self assert: self comment parse: '""' to: '""'.
	self assert: self comment parse: '"a"' to: '"a"'.
	self assert: self comment parse: '"ab"' to: '"ab"'.
	self assert: self comment parse: '"abc"' to: '"abc"'.

	self assert: self comment parse: '""a' to: '""' end: 2.
	self assert: self comment parse: '"a"a' to: '"a"' end: 3.
	self assert: self comment parse: '"ab"a' to: '"ab"' end: 4.
	self assert: self comment parse: '"abc"a' to: '"abc"' end: 5.

	self assert: self comment fail: '"'.
	self assert: self comment fail: '"a'.
	self assert: self comment fail: '"aa'.
	self assert: self comment fail: 'a"'.
	self assert: self comment fail: 'aa"'
]

{ #category : #testing }
PPExamplesTest >> testIdentifier [
	self assert: self identifier parse: 'a' to: 'a'.
	self assert: self identifier parse: 'a1' to: 'a1'.
	self assert: self identifier parse: 'a12' to: 'a12'.
	self assert: self identifier parse: 'ab' to: 'ab'.
	self assert: self identifier parse: 'a1b' to: 'a1b'.

	self assert: self identifier parse: 'a_' to: 'a' end: 1.
	self assert: self identifier parse: 'a1-' to: 'a1' end: 2.
	self assert: self identifier parse: 'a12+' to: 'a12' end: 3.
	self assert: self identifier parse: 'ab^' to: 'ab' end: 2.
	self assert: self identifier parse: 'a1b*' to: 'a1b' end: 3.

	self assert: self identifier fail: ''.
	self assert: self identifier fail: ' '.
	self assert: self identifier fail: '1'.
	self assert: self identifier fail: '1a'
]

{ #category : #testing }
PPExamplesTest >> testNumber [
	self assert: self number parse: '1' to: '1'.
	self assert: self number parse: '12' to: '12'.
	self assert: self number parse: '12.3' to: '12.3'.
	self assert: self number parse: '12.34' to: '12.34'.

	self assert: self number parse: '1..' to: '1' end: 1.
	self assert: self number parse: '12-' to: '12' end: 2.
	self assert: self number parse: '12.3.' to: '12.3' end: 4.
	self assert: self number parse: '12.34.' to: '12.34' end: 5.
	
	self assert: self number parse: '-1' to: '-1'.
	self assert: self number parse: '-12' to: '-12'.
	self assert: self number parse: '-12.3' to: '-12.3'.
	self assert: self number parse: '-12.34' to: '-12.34'.
	
	self assert: self number fail: ''.
	self assert: self number fail: '-'.
	self assert: self number fail: '.'.
	self assert: self number fail: '.1'
]

{ #category : #testing }
PPExamplesTest >> testReturn [
	| number spaces return |
	number := #digit asParser plus flatten.
	spaces := #space asParser star.
	return := (spaces , $^ asParser , spaces , number)
		==> [ :nodes | { #return. nodes at: 4 } ].

	self assert: return parse: '^1' to: #(return '1').
	self assert: return parse: ' ^12' to: #(return '12').
	self assert: return parse: '^123 ' to: #(return '123').
	self assert: return parse: '^ 1234' to: #(return '1234').
	
	self assert: return fail: '1'.
	self assert: return fail: '^'
]
