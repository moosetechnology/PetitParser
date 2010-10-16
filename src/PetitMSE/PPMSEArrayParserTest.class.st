Class {
	#name : #PPMSEArrayParserTest,
	#superclass : #PPMSEGrammarTest,
	#category : #PetitMSE
}

{ #category : #accessing }
PPMSEArrayParserTest >> parserClass [
	^ PPMSEArrayParser
]

{ #category : #testing }
PPMSEArrayParserTest >> testEmpty [
	self assert: '()' is: #().
	self assert: '( )' is: #().
	self assert: ' ( ) ' is: #()
]

{ #category : #testing }
PPMSEArrayParserTest >> testOneElement [
	self assert: '((X))' is: #(('X' nil #())).
	self assert: '((X.Y))' is: #(('X.Y' nil #())).
	
]

{ #category : #testing }
PPMSEArrayParserTest >> testOneElementWithBooleanAttribute [
	self assert: '((X.Y (attribute true)))' is: #(('X.Y' nil #(('attribute' true))))
]

{ #category : #testing }
PPMSEArrayParserTest >> testOneElementWithId [
	self assert: '((FAMIX.Class (id: 1)))' is: #(('FAMIX.Class' #('id' 1) #())).
	self assert: '( ( FAMIX.Class (id: 1) ) )' is: #(('FAMIX.Class' #('id' 1) #())).
	self assert: '( 
	( FAMIX.Class (id: 1) )
)' is: #(('FAMIX.Class' #('id' 1) #())).
	self assert: '( 
(FAMIX.Class (id: 1)
)
)' is: #(('FAMIX.Class' #('id' 1) #()))
]

{ #category : #testing }
PPMSEArrayParserTest >> testOneElementWithMultipleSubElements [
	self assert: '((X (sub (Y) (Z))))' is: #(#('X' nil #(#('sub' #(#('Y' nil #()) #('Z' nil #())))))).
	
]

{ #category : #testing }
PPMSEArrayParserTest >> testOneElementWithNumericAttribute [
	self assert: '((X.Y (attribute 2)))' is: #(('X.Y' nil #(('attribute' 2)))).
	self assert: '((X.Y (attribute 2.1)))' is: #(('X.Y' nil #(('attribute' 2.1)))).
	self assert: '((X.Y (attribute 1234.567)))' is: #(('X.Y' nil #(('attribute' 1234.567))))
]

{ #category : #testing }
PPMSEArrayParserTest >> testOneElementWithStringAttribute [
	self assert: '((FAMIX.Class (name ''Something'')))' is: #(('FAMIX.Class' nil #(('name' 'Something')))).
	self assert: '((FAMIX.Class (attribute ''as:.,><asd'')))' is: #(('FAMIX.Class' nil #(('attribute' 'as:.,><asd')))).
]

{ #category : #testing }
PPMSEArrayParserTest >> testOneElementWithSubElement [
	self assert: '((X (sub (Y))))' is: #(#('X' nil #(#('sub' #('Y' nil #())))))
]
