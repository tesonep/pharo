Extension { #name : #ClassDescription }

{ #category : #'*TraitsV2' }
ClassDescription >> asTraitComposition [

	^ TaCompositionElement for: self
]

{ #category : #'*TraitsV2' }
ClassDescription >> traitComposition [
	^ TaEmptyComposition new
]
