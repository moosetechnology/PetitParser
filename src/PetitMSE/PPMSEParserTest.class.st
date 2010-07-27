Class {
	#name : #PPMSEParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #PetitMSE
}

{ #category : #accessing }
PPMSEParserTest >> parserClass [
	^ PPMSEParser
]

{ #category : #testing }
PPMSEParserTest >> testEmpty [
	self assert: '()' is: #().
	self assert: '( )' is: #().
	self assert: ' ( ) ' is: #()
]

{ #category : #testing }
PPMSEParserTest >> testOneElement [
	self assert: '((FAMIX.Class))' is: #(('FAMIX.Class' nil #()))
]

{ #category : #testing }
PPMSEParserTest >> testOneElementWithId [
	self assert: '((FAMIX.Class (id: 1)))' is: #(('FAMIX.Class' #('id' 1) #()))
]
