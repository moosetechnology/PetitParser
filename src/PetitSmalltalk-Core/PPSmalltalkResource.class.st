Class {
	#name : #PPSmalltalkResource,
	#superclass : #TestResource,
	#instVars : [
		'parsers'
	],
	#category : #'PetitSmalltalk-Tests'
}

{ #category : #accessing }
PPSmalltalkResource >> parserAt: aClass [ 
	^ parsers 
		at: aClass name
		ifAbsentPut: [ aClass new ]
]

{ #category : #running }
PPSmalltalkResource >> setUp [
	super setUp.
	parsers := Dictionary new
]
