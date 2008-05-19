Class {
	#name : #PPCompilerAdapter,
	#superclass : #Object,
	#instVars : [
		'parserClass'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #'instance-creation' }
PPCompilerAdapter class >> on: aParserClass [
	^ self basicNew initializeOn: aParserClass
]

{ #category : #compiling }
PPCompilerAdapter >> compile: aString in: aClass classified: aSymbol notifying: aRequestor ifFail: aBlock [
	^ self parserClass
		parse: aString
		ifError: [ :error |
			^ aRequestor requestor
				notify: error reason
				at: error position + 1
				in: aString ]
]

{ #category : #decompiling }
PPCompilerAdapter >> decompile: aSelector in: aClass method: aCompiledMethod [
	^ Decompiler new decompile: aSelector in: aClass method: aCompiledMethod
]

{ #category : #accessing }
PPCompilerAdapter >> decompilerClass [
	^ self
]

{ #category : #initialization }
PPCompilerAdapter >> initializeOn: aParserClass [
	parserClass := aParserClass
]

{ #category : #adapting }
PPCompilerAdapter >> new [
]

{ #category : #accessing }
PPCompilerAdapter >> parserClass [
	^ parserClass
]

{ #category : #adapting }
PPCompilerAdapter >> withTempNames: anArray [
]
