Class {
	#name : #PPTokenOLParser,
	#superclass : #PPTokenParser,
	#category : #'PetitIndent-Offside-rule'
}

{ #category : #'as yet unclassified' }
PPTokenOLParser >> asCompilerNode [
	self flag: 'TODO'.
	
	^ PPCUnknownNode new
		parser: self;
		name: self name;
		yourself
]

{ #category : #'as yet unclassified' }
PPTokenOLParser >> parseOn: context [
	((context indentStack topIfEmpty: 1) <= context column) ifFalse: [  
		^ PPFailure message: 'Not aligned or onside' context: context
	].
	^ super parseOn: context
]
