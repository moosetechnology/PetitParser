Class {
	#name : #PPManifestMfParserTest,
	#superclass : #PPCompositeParserTest,
	#category : #PetitManifestMf
}

{ #category : #'as yet unclassified' }
PPManifestMfParserTest >> parserClass [
	^ PPManifestMfParser
]

{ #category : #'as yet unclassified' }
PPManifestMfParserTest >> testSinglePair [
	self assert: 'Header: value' is: {'header'->'value'}
]
