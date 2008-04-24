Class {
	#name : #PPMemento,
	#superclass : #Object,
	#instVars : [
		'result',
		'count',
		'position'
	],
	#category : #'PetitParser-Core'
}

{ #category : #'as yet unclassified' }
PPMemento class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
PPMemento >> count [
	^ count
]

{ #category : #accessing }
PPMemento >> count: anInteger [
	count := anInteger
]

{ #category : #action }
PPMemento >> increment [
	count := count + 1
]

{ #category : #initialization }
PPMemento >> initialize [
	count := 0
	
]

{ #category : #accessing }
PPMemento >> position [
	^ position
]

{ #category : #accessing }
PPMemento >> position: anObject [
	position := anObject
]

{ #category : #accessing }
PPMemento >> result: anObject [
	result := anObject
]
