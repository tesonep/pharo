Extension { #name : #Metaclass }

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray [
	| copyOfOldTrait newComposition |
	
	self halt.
	
	copyOfOldTrait := self copy.
	newComposition := aTraitCompositionOrArray asTraitComposition.
	self assertConsistantCompositionsForNew: newComposition.
	self setTraitComposition: newComposition.
	SystemAnnouncer uniqueInstance
		traitDefinitionChangedFrom: copyOfOldTrait to: self;
		classModificationAppliedTo: self
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray instanceVariableNames: instVarString [ 
	| newComposition newMetaClass copyOfOldMetaClass |
	
	self halt.
	
	copyOfOldMetaClass := self copy.
	newMetaClass := self instanceVariableNames: instVarString.
	
	newComposition := aTraitCompositionOrArray asTraitComposition.
	newMetaClass assertConsistantCompositionsForNew: newComposition.
	newMetaClass setTraitComposition: newComposition.
	
	SystemAnnouncer uniqueInstance
		classDefinitionChangedFrom: copyOfOldMetaClass to: newMetaClass
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray slots: slotArray [ 
	| newComposition newMetaClass copyOfOldMetaClass |
	
	self halt.
	
	copyOfOldMetaClass := self copy.
	newMetaClass := self slots: slotArray.
	
	newComposition := aTraitCompositionOrArray asTraitComposition.
	newMetaClass assertConsistantCompositionsForNew: newComposition.
	newMetaClass setTraitComposition: newComposition.
	
	SystemAnnouncer uniqueInstance
		classDefinitionChangedFrom: copyOfOldMetaClass to: newMetaClass
]
