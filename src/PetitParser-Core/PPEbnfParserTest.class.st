Class {
	#name : #PPEbnfParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitParser-Tests'
}

{ #category : #accessing }
PPEbnfParserTest >> parseClass [
	^ PPEbnfParser
]

{ #category : #testing }
PPEbnfParserTest >> testExpression [
	| result |
	result := self parse: 'foo = bar | zork ;'.
	self assert: result third first value first value = 'bar'
]

{ #category : #testing }
PPEbnfParserTest >> testGroup [
	| result |
	result := self parse: 'foo = (bar) ;'.
	self assert: result third first first second first first value = 'bar'
]

{ #category : #testing }
PPEbnfParserTest >> testList [
	| result |
	result := self parse: 'foo = bar zork ;'.
	self assert: result third first value first value = 'bar'.
	self assert: result third first value second value = 'zork'
]

{ #category : #testing }
PPEbnfParserTest >> testOptional [
	| result |
	result := self parse: 'foo = [ bar ] ;'.
	self assert: result third first first second first first value = 'bar'
]

{ #category : #testing }
PPEbnfParserTest >> testRepetition [
	| result |
	result := self parse: 'foo = { bar } ;'.
	self assert: result third first first second first first value = 'bar'
]

{ #category : #testing }
PPEbnfParserTest >> testRule [
	| result |
	result := self parse: 'foo = bar ;'.
	self assert: result first value = 'foo'.
	self assert: result second value = '='.
	self assert: result fourth value = ';'
]

{ #category : #testing }
PPEbnfParserTest >> testTerminal [
	| result |
	result := self parse: 'foo = "baz" ;'.
	self assert: result third first first value = '"baz"'.
	
	result := self parse: 'foo = ''baz'' ;'.
	self assert: result third first first value = '''baz'''
]
