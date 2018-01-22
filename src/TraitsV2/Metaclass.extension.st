Extension { #name : #Metaclass }

{ #category : #'*TraitsV2' }
Metaclass >> setTraitComposition: aTraitCompositionOrArray [
	
	^ self uses: aTraitCompositionOrArray slots: self slots.
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray [
	
	^ self uses: aTraitCompositionOrArray slots: #().
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray instanceVariableNames: instVarString [ 
	
	^ self uses: aTraitCompositionOrArray slots: instVarString asSlotCollection
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray slots: slotArray [
	| theClass builderEnhancer |
	theClass := self theNonMetaClass.
	
	theClass := theClass classInstaller
		update: theClass
		to: [ :builder | 
			builder
				superclass: theClass superclass;
				name: theClass name;
				layoutClass: theClass classLayout class;
				slots: theClass slots;
				sharedVariablesFromString: theClass classVariablesString;
				sharedPools: theClass sharedPoolsString;
				traitComposition: theClass traitComposition;
				traitComposition: theClass traitComposition asTraitComposition;
				classTraitComposition: aTraitCompositionOrArray asTraitComposition;				
				category: theClass category asString;
				classSlots: slotArray ].
	^ theClass theMetaClass
]
