Class {
	#name : #PPCompositeParser,
	#superclass : #PPParser,
	#instVars : [
		'productions'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #rules }
PPCompositeParser class >> transformParser [
	<transform: 100>

	^ DSLConditionPattern new
		if: [ :visitor | visitor tree isMethod and: [ visitor selector isUnary and: [ visitor theClass ~= PPCompositeParser ] ] ]
		then: (Array
			with: (DSLSearchPattern new
				expression: '`#var';
				action: [ :visitor |
					(visitor node value isString or: [ visitor node value isCharacter ])
						ifTrue: [ visitor node replaceWith: ``(`,(visitor node value) asParser) ] ])
			with: (DSLSearchPattern new
				expression: '`var';
				action: [ :visitor |
					((Smalltalk hasClassNamed: visitor node name)
						or: [ (visitor tree allDefinedVariables includes: visitor node name)
						or: [ (visitor theClass allInstVarNames includes: visitor node name) ] ])
						ifFalse: [ visitor node replaceWith: ``(self productionAt: `,(visitor node name asSymbol)) ] ])
			with: [ :visitor |
				visitor tree body lastIsReturn ifTrue: [
					visitor tree body statements last
						replaceWith: visitor tree body statements last value ].
				visitor tree body addNodeFirst: ``(self
					productionAt: `,(visitor tree selector)
					ifAbsentPut: [ `,(visitor tree body) ]).
				visitor tree body statements allButFirst
					do: [ :each | visitor tree body removeNode: each ].
				visitor tree body addReturn ])
]

{ #category : #initialization }
PPCompositeParser >> initialize [
	super initialize.
	productions := Dictionary new
]

{ #category : #parsing }
PPCompositeParser >> parse: aStream [
	forwarder isNil
		ifFalse: [ self transformForwarder ].
	^ start parse: aStream
]

{ #category : #private }
PPCompositeParser >> performInitializer [
	self class allSelectors do: [ :selector |
		(selector isUnary and: [ selector size > #initialize size and: [ selector beginsWith: #initialize ] ])
			ifTrue: [ self perform: selector ] ]
]

{ #category : #private }
PPCompositeParser >> prepareForwarder [
	forwarder := Array new: self class instSize - 1.
	1 to: forwarder size do: [ :index |
		forwarder at: index put: (self 
			instVarAt: index + 1
			put: PPForwarderParser new) ]
]

{ #category : #accessing }
PPCompositeParser >> productionAt: aSymbol [
	^ productions at: aSymbol ifAbsentPut: [ PPUnresolvedParser on: self name: aSymbol ]
]

{ #category : #accessing }
PPCompositeParser >> productionAt: aSymbol ifAbsentPut: aBlock [
	| production |
	production := productions at: aSymbol ifAbsentPut: aBlock.
	production isUnresolved
		ifTrue: [ production becomeForward: aBlock value ].
	^ production
]

{ #category : #private }
PPCompositeParser >> transformForwarder [
	| target |
	target := Array new: forwarder size.
	1 to: target size do: [ :index |
		target
			at: index
			put: (self instVarAt: index + 1) ].
	forwarder elementsForwardIdentityTo: target. 
	forwarder := nil
]
