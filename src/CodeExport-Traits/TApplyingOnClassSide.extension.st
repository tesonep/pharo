Extension { #name : #TApplyingOnClassSide }

{ #category : #'*CodeExport-Traits' }
TApplyingOnClassSide >> fileOutInitializerOn: aStream [
	(self includesSelector: #initialize) ifTrue: 
		[aStream cr.
		aStream nextChunkPut: self soleInstance name , ' initialize'].
]

{ #category : #'*CodeExport-Traits' }
TApplyingOnClassSide >> nonTrivial [ 
	"Answer whether the receiver has any methods or instance variables."

	^ self instVarNames notEmpty or: [self hasMethods or: [self hasTraitComposition]]
]
