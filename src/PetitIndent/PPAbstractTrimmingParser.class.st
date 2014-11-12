Class {
	#name : #PPAbstractTrimmingParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'trimmingParser',
		'context'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPAbstractTrimmingParser >> commentsParser: aPPContext [
	| comments commentsParser |
	comments := aPPContext propertyAt: #comments ifAbsent: [ #() ].
	(comments isEmpty not) ifTrue: [ 
		commentsParser := PPChoiceParser withAll: comments.
	] ifFalse: [ 
		commentsParser := PPFailingParser new
	].

	^ commentsParser
]

{ #category : #'as yet unclassified' }
PPAbstractTrimmingParser >> parseOn: aPPContext [
	^ (self trimmingParser: aPPContext) parseOn: aPPContext
]

{ #category : #'as yet unclassified' }
PPAbstractTrimmingParser >> reset: aPPContext [
	context := aPPContext.
	trimmingParser := nil.
]

{ #category : #'as yet unclassified' }
PPAbstractTrimmingParser >> trimmingParser: aPPContext [
	(context == aPPContext) ifFalse: [ self reset: aPPContext  ].
	
	trimmingParser ifNil: [ trimmingParser := self createTrimmingParser: aPPContext].
	^ trimmingParser 
]
