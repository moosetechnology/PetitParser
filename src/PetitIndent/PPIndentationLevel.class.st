"
A PPIndentationLevel is a singleton and the default reference to indentation level used by PetitIndent extension.

"
Class {
	#name : #PPIndentationLevel,
	#superclass : #PPDelegateParser,
	#classVars : [
		'Instance'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPIndentationLevel class >> instance [
	Instance ifNil: [ 
		Instance := self basicNew initialize
						setParser: (nil asParser);
						name: 'indentation level'; 
						yourself.
	].
	^ Instance
]

{ #category : #'as yet unclassified' }
PPIndentationLevel class >> new [
	^ self instance
]
