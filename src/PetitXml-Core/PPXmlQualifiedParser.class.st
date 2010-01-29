Class {
	#name : #PPXmlQualifiedParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'prefix',
		'local'
	],
	#category : #'PetitXml-Support'
}

{ #category : #'instance creation' }
PPXmlQualifiedParser class >> local: aParser [
	^ self basicNew local: aParser
]

{ #category : #testing }
PPXmlQualifiedParser >> isQualified [
	^ prefix notNil
]

{ #category : #accessing }
PPXmlQualifiedParser >> local: aParser [
	local := aParser asParser.
	self update
]

{ #category : #accessing }
PPXmlQualifiedParser >> prefix: aParser [
	prefix := aParser asParser.
	self update
]

{ #category : #updating }
PPXmlQualifiedParser >> update [
	parser := prefix isNil
		ifTrue: [ local ]
		ifFalse: [ parser := prefix , $: asParser , local ].
	parser := parser flatten
]
