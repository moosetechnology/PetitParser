Class {
	#name : #PPFactorialParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #token }
PPFactorialParser >> add [
	$+ token
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
	$) token
]

{ #category : #token }
PPFactorialParser >> cmp [
	'==' token
]

{ #category : #grammar }
PPFactorialParser >> condition [
	if , expression , then , expression , else , expression
]

{ #category : #token }
PPFactorialParser >> else [
	'else' token
]

{ #category : #token }
PPFactorialParser >> equal [
	$= token
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
	#letter plus token
]

{ #category : #token }
PPFactorialParser >> if [
	'if' token
]

{ #category : #grammar }
PPFactorialParser >> literal [
	num
]

{ #category : #token }
PPFactorialParser >> num [
	#digit plus token ==> #asNumber
]

{ #category : #token }
PPFactorialParser >> open [
	$( token
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
	$- token
]

{ #category : #token }
PPFactorialParser >> then [
	'then' token
]

{ #category : #grammar }
PPFactorialParser >> variable [
	id
]
