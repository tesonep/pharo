Extension { #name : #TraitBehavior }

{ #category : #'*ast-core-traits' }
TraitBehavior >> parseTreeFor: aSymbol [	
	^ RBParser parseMethod: (self sourceCodeAt: aSymbol) onError: [ :msg :pos | ^ nil ]
]
