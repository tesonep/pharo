Extension { #name : #TBehavior }

{ #category : #'*ast-core-traits' }
TBehavior >> parseTreeFor: aSymbol [	
	^ RBParser parseMethod: (self sourceCodeAt: aSymbol) onError: [ :msg :pos | ^ nil ]
]
