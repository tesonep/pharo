Extension { #name : #Behavior }

{ #category : #'*TraitsV2' }
Behavior >> removeFromComposition: aTrait [
	self setTraitComposition: (self traitComposition copyTraitExpression
		removeFromComposition: aTrait)
]
