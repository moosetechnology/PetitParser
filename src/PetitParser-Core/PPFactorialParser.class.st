Class {
	#name : #PPFactorialParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #token }
PPFactorialParser >> add [
	$+ flatten
]

{ #category : #grammar }
PPFactorialParser >> apply [
	open , id , expression star , close
]

{ #category : #grammar }
PPFactorialParser >> binary [
	open , expression , operation , expression , close
]

{ #category : #token }
PPFactorialParser >> close [
	$) flatten
]

{ #category : #token }
PPFactorialParser >> cmp [
	'==' flatten
]

{ #category : #grammar }
PPFactorialParser >> condition [
	if , expression , then , expression , else , expression
]

{ #category : #token }
PPFactorialParser >> else [
	'else' flatten
]

{ #category : #token }
PPFactorialParser >> equal [
	$= flatten
]

{ #category : #grammar }
PPFactorialParser >> expression [
	apply | condition | binary | variable | literal
]

{ #category : #grammar }
PPFactorialParser >> function [
	id , variable star , equal , expression
]

{ #category : #token }
PPFactorialParser >> id [
	#letter plus flatten
]

{ #category : #token }
PPFactorialParser >> if [
	'if' flatten
]

{ #category : #grammar }
PPFactorialParser >> literal [
	num
]

{ #category : #token }
PPFactorialParser >> num [
	#digit plus flatten
]

{ #category : #token }
PPFactorialParser >> open [
	$( flatten
]

{ #category : #grammar }
PPFactorialParser >> operation [
	cmp | add | sub
]

{ #category : #accessing }
PPFactorialParser >> start [
	function end
]

{ #category : #token }
PPFactorialParser >> sub [
	$- flatten
]

{ #category : #token }
PPFactorialParser >> then [
	'then' flatten
]

{ #category : #grammar }
PPFactorialParser >> variable [
	id
]
