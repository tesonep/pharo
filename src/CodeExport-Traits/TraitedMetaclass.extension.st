Extension { #name : #TraitedMetaclass }

{ #category : #'*CodeExport-Traits' }
TraitedMetaclass >> fileOutLocalMethodsInCategory: aSymbol on: aFileStream [
	"File out only the local (non-trait) methods for this category."

	| selectors locals |
	
	aFileStream cr.
	selectors := self selectorsToFileOutCategory: aSymbol.
   locals := selectors select:[:s | self isLocalSelector: s ].
	"Overridden to preserve author stamps in sources file regardless"
	locals do: [:sel |
		self printMethodChunk: sel on: aFileStream ].
	^ self
]
