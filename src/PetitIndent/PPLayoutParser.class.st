Class {
	#name : #PPLayoutParser,
	#superclass : #PPParser,
	#instVars : [
		'context',
		'layoutParser'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPLayoutParser >> commentsParser: aPPContext [
	| comments commentsParser |
	comments := aPPContext globalAt: #comments ifAbsent: [ #() ].
	(comments isEmpty not) ifTrue: [ 
		commentsParser := PPChoiceParser withAll: comments.
	] ifFalse: [ 
		commentsParser := PPFailingParser new setMessage: ''; yourself
	].

	^ commentsParser
]

{ #category : #'as yet unclassified' }
PPLayoutParser >> createLayoutParser: aPPContext [
	|    commentsParser |
	commentsParser := self commentsParser: aPPContext.
	^ #blank asParser / commentsParser.
]

{ #category : #'as yet unclassified' }
PPLayoutParser >> layoutParser: aPPContext [
	(context == aPPContext) ifFalse: [ self reset: aPPContext ].

	layoutParser ifNil: [ 
		layoutParser := self createLayoutParser: aPPContext.
	].

	^ layoutParser
]

{ #category : #'as yet unclassified' }
PPLayoutParser >> parseOn: aPPContext [
	^ (self layoutParser: aPPContext) parseOn: aPPContext
]

{ #category : #'as yet unclassified' }
PPLayoutParser >> reset: aPPContext [
	context := aPPContext.
	layoutParser := nil.
]
