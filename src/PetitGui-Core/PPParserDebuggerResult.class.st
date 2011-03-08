Class {
	#name : #PPParserDebuggerResult,
	#superclass : #Object,
	#instVars : [
		'parser',
		'result',
		'children',
		'parent'
	],
	#category : #'PetitGui-Core'
}

{ #category : #'instance creation' }
PPParserDebuggerResult class >> parse: aStream with: parser [ 
	| root newParser |
	root := self new.
	newParser := parser transform: [:each |
		each name isNil 
			ifTrue: [each ]
			ifFalse: [
				each >=> [:stream :continuation | 
					| result child |
					child := PPParserDebuggerResult new 
							parser: each;
							parent: root.
					root := root children add: child.
					result := continuation value.
					root result: result.
					root := root parent.
					result ]]].
	newParser parse: aStream.
	^ root
]

{ #category : #accessing }
PPParserDebuggerResult >> children [
	^ children
]

{ #category : #accessing }
PPParserDebuggerResult >> children: anObject [
	children := anObject
]

{ #category : #initialization }
PPParserDebuggerResult >> initialize [ 
	children := OrderedCollection new
]

{ #category : #accessing }
PPParserDebuggerResult >> parent [
	^ parent
]

{ #category : #accessing }
PPParserDebuggerResult >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
PPParserDebuggerResult >> parser [
	^ parser
]

{ #category : #accessing }
PPParserDebuggerResult >> parser: anObject [
	parser := anObject
]

{ #category : #accessing }
PPParserDebuggerResult >> result [
	^ result
]

{ #category : #accessing }
PPParserDebuggerResult >> result: anObject [
	result := anObject
]
