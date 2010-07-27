Class {
	#name : #PPMSEParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #PetitMSE
}

{ #category : #accessing }
PPMSEParserTest >> parserClass [
	^ PPMSEArrayParser
]

{ #category : #testing }
PPMSEParserTest >> testEmpty [
	self assert: '()' is: #().
	self assert: '( )' is: #().
	self assert: ' ( ) ' is: #()
]

{ #category : #testing }
PPMSEParserTest >> testOneElement [
	self assert: '((X.Y))' is: #(('X.Y' nil #())).
	self assert: '((X))' is: #(('X' nil #()))
]

{ #category : #testing }
PPMSEParserTest >> testOneElementWithBooleanAttribute [
	self assert: '((X.Y (attribute true)))' is: #(('X.Y' nil #(('attribute' true))))
]

{ #category : #testing }
PPMSEParserTest >> testOneElementWithId [
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
PPMSEParserTest >> testOneElementWithNumericAttribute [
	self assert: '((X.Y (attribute 2)))' is: #(('X.Y' nil #(('attribute' 2)))).
	self assert: '((X.Y (attribute 2.1)))' is: #(('X.Y' nil #(('attribute' 2.1)))).
	self assert: '((X.Y (attribute 1234.567)))' is: #(('X.Y' nil #(('attribute' 1234.567))))
]

{ #category : #testing }
PPMSEParserTest >> testOneElementWithStringAttribute [
	self assert: '((FAMIX.Class (name ''Something'')))' is: #(('FAMIX.Class' nil #(('name' 'Something')))).
	self assert: '((FAMIX.Class (attribute ''as:.,><asd'')))' is: #(('FAMIX.Class' nil #(('attribute' 'as:.,><asd')))).
]
