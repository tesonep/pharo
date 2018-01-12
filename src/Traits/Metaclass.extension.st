Extension { #name : #Metaclass }

{ #category : #'*Traits' }
Metaclass >> uses: aTraitCompositionOrArray [
	| copyOfOldTrait newComposition |
	copyOfOldTrait := self copy.
	newComposition := aTraitCompositionOrArray asTraitComposition.
	self assertConsistantCompositionsForNew: newComposition.
	self setTraitComposition: newComposition.
	SystemAnnouncer uniqueInstance
		traitDefinitionChangedFrom: copyOfOldTrait to: self;
		classModificationAppliedTo: self
]

{ #category : #'*Traits' }
Metaclass >> uses: aTraitCompositionOrArray instanceVariableNames: instVarString [ 
	| newComposition newMetaClass copyOfOldMetaClass |
	
	copyOfOldMetaClass := self copy.
	newMetaClass := self instanceVariableNames: instVarString.
	
	newComposition := aTraitCompositionOrArray asTraitComposition.
	newMetaClass assertConsistantCompositionsForNew: newComposition.
	newMetaClass setTraitComposition: newComposition.
	
	SystemAnnouncer uniqueInstance
		classDefinitionChangedFrom: copyOfOldMetaClass to: newMetaClass
]

{ #category : #'*Traits' }
Metaclass >> uses: aTraitCompositionOrArray slots: slotArray [ 
	| newComposition newMetaClass copyOfOldMetaClass |
	
	copyOfOldMetaClass := self copy.
	newMetaClass := self slots: slotArray.
	
	newComposition := aTraitCompositionOrArray asTraitComposition.
	newMetaClass assertConsistantCompositionsForNew: newComposition.
	newMetaClass setTraitComposition: newComposition.
	
	SystemAnnouncer uniqueInstance
		classDefinitionChangedFrom: copyOfOldMetaClass to: newMetaClass
]
