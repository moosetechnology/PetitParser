Class {
	#name : #PPGrammarResource,
	#superclass : #TestResource,
	#instVars : [
		'parsers'
	],
	#category : #'PetitSmalltalk-Tests'
}

{ #category : #accessing }
PPGrammarResource >> parserAt: aClass [ 
	^ parsers 
		at: aClass name
		ifAbsentPut: [ aClass new ]
]

{ #category : #running }
PPGrammarResource >> setUp [
	super setUp.
	parsers := Dictionary new
]
