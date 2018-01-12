Extension { #name : #ClassTrait }

{ #category : #'*CodeExport-Traits' }
ClassTrait >> fileOutInitializerOn: aStream [
	(self includesSelector: #initialize) ifTrue: 
		[aStream cr.
		aStream nextChunkPut: self soleInstance name , ' initialize'].
]

{ #category : #'*CodeExport-Traits' }
ClassTrait >> nonTrivial [ 
	"Answer whether the receiver has any methods or instance variables."

	^ self instVarNames notEmpty or: [self hasMethods or: [self hasTraitComposition]]
]
