Class {
	#name : #PPFactorialPrinter,
	#superclass : #PPFactorialParser,
	#category : #'PetitParser-Builder'
}

{ #category : #grammar }
PPFactorialPrinter >> apply [
	^ super apply ==> [ :node | '(' , node second , ' ' , (node third fold: [ :a :b | a , ' ' , b ]) , ')' ]
]

{ #category : #grammar }
PPFactorialPrinter >> binary [
	^ super binary ==> [ :node | '(' , node second , ' ' , node third , ' ' , node fourth , ')' ]
]

{ #category : #grammar }
PPFactorialPrinter >> condition [
	^ super condition ==> [ :node | 'if ' , node second , ' then ' , node fourth , ' else ' , node sixth ]
]

{ #category : #grammar }
PPFactorialPrinter >> function [
	^ super function ==> [ :node | node first , ' ' , (node second fold: [ :a :b | a , ' ' , b ]) , ' = ' , node fourth ]
]
