Extension { #name : #ClassDescription }

{ #category : #'*TraitsV2' }
ClassDescription >> asTraitComposition [

	^ TaCompositionElement for: self
]

{ #category : #'*TraitsV2' }
ClassDescription >> baseComposition [
	^ TaEmptyComposition new
]

{ #category : #'*TraitsV2' }
ClassDescription >> baseLocalMethods [
	^ self baseClass methodDict
]

{ #category : #'*TraitsV2' }
ClassDescription >> traitComposition [
	^ TaEmptyComposition new
]
