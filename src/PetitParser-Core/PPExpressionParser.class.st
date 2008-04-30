Class {
	#name : #PPExpressionParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #productions }
PPExpressionParser >> expression [
		(expression , ($+ | $-) token , term)
	|	(term)
]

{ #category : #productions }
PPExpressionParser >> factor [
		($( , expression , $))
	|	(number)
]

{ #category : #productions }
PPExpressionParser >> number [
	#digit plus token
]

{ #category : #accessing }
PPExpressionParser >> startProduction [
	expression end
]

{ #category : #productions }
PPExpressionParser >> term [
		(term , ($* | $/) token , factor)
	|	(factor)
]
