Class {
	#name : #PPMemoizingIslandTest,
	#superclass : #PPIslandTest,
	#category : #'PetitIslands-Tests'
}

{ #category : #'as yet unclassified' }
PPMemoizingIslandTest class >> shouldInheritSelectors [ 
	^ true.
]

{ #category : #'as yet unclassified' }
PPMemoizingIslandTest >> islandClass [
	^ PPMemoizingIsland 
]

{ #category : #testing }
PPMemoizingIslandTest >> testMemo [
	| parser  result1 result2 input |
	
	parser := self island: ('class' asParser, self identifier, 'endclass' asParser).
	input := 'class Foo endclass' asPetitStream.
	
	context := PPContext new.
	
	result1 :=  parser parse: input withContext: context.
	result2 := parser parse: input withContext: context.
	self assert: (result1 == result2 ).
]
