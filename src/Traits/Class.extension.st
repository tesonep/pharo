Extension { #name : #Class }

{ #category : #'*Traits' }
Class >> applyChangesOfNewTraitCompositionReplacing: oldComposition [

	| changedSelectors |
	changedSelectors := super applyChangesOfNewTraitCompositionReplacing: oldComposition.
	self classSide noteNewBaseTraitCompositionApplied: self traitComposition.
	^ changedSelectors
]

{ #category : #'*Traits' }
Class >> immediateSubclass: aClassName uses: aTraitCompositionOrArray instanceVariableNames: instVarNames 
	classVariableNames: classVarNames package: cat [
	"Added to allow for a simplified subclass creation experience. "
	
	^ self immediateSubclass: aClassName 
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames  
		classVariableNames: classVarNames 
		poolDictionaries: ''
		package: cat
]

{ #category : #'*Traits' }
Class >> immediateSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames package: aCategory [
	"Creates a new class as a subclass of an existing class (the receiver) 
	in which the subclass is to have indexable byte-sized nonpointer variables."
	
	^ self
		subclass: aName
		uses: aTraitComposition
		with: [ 
			self
				immediateSubclass: aName
				instanceVariableNames: someInstanceVariableNames
				classVariableNames: someClassVariableNames
				poolDictionaries: someSharedPoolNames
				package: aCategory ]
]

{ #category : #'*Traits' }
Class >> name: aString traitComposition: aComposition methodDict: aMethodDict localSelectors: aSet organization: aClassOrganization [

	"Used by copy"
	
	self name: aString.
	self localSelectors: aSet.
	self methodDict: aMethodDict.
	self traitComposition: aComposition.
	self organization: aClassOrganization
]

{ #category : #'*Traits' }
Class >> subclass: t uses: aTraitComposition [ 
	| cls |
	cls := self
				subclass: t
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: ''
				category: 'Unclassified'.
	cls setTraitComposition: aTraitComposition asTraitComposition.
	^ cls
]

{ #category : #'*Traits' }
Class >> subclass: aTraitName uses: aTraitCompositionOrArray instanceVariableNames: instVarNames classVariableNames: classVarNames category: cat [ 

	^ self
		subclass: aTraitName
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames
		classVariableNames: classVarNames
		poolDictionaries: ''
		category: cat 
]

{ #category : #'*Traits' }
Class >> subclass: aTraitName uses: aTraitCompositionOrArray instanceVariableNames: instVarNames classVariableNames: classVarNames package: cat [
	^ self
		subclass: aTraitName
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames
		classVariableNames: classVarNames
		category: cat
]

{ #category : #'*Traits' }
Class >> subclass: aName uses: aTraitCompositionOrArray instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames category: aCategory [

	^ self
		subclass: aName
		uses: aTraitCompositionOrArray
		with: [ 
			self
				private_subclass: aName
				instanceVariableNames: someInstanceVariableNames
				classVariableNames: someClassVariableNames
				poolDictionaries: someSharedPoolNames
				category: aCategory ]
]

{ #category : #'*Traits' }
Class >> subclass: aName uses: aTraitCompositionOrArray instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames package: aCategory [

	^ self
		subclass: aName
		uses: aTraitCompositionOrArray
		with: [ 
			self
				private_subclass: aName
				instanceVariableNames: someInstanceVariableNames
				classVariableNames: someClassVariableNames
				poolDictionaries: someSharedPoolNames
				category: aCategory ]
]

{ #category : #'*Traits' }
Class >> subclass: aSubclassSymbol uses: aTraitCompositionOrArray  layout: layoutClass slots: slotDefinition classVariables: classVarDefinition category: aCategorySymbol [
	^ self
		subclass: aSubclassSymbol
		uses: aTraitCompositionOrArray
		with: [ 
			self classInstaller
				make: [ :builder | 
					builder
						name: aSubclassSymbol;
						superclass: self;
						layoutClass: layoutClass;
						slots: slotDefinition;
						sharedVariables: classVarDefinition;
						category: aCategorySymbol ] ]
]

{ #category : #'*Traits' }
Class >> subclass: aSubclassSymbol uses: aTraitCompositionOrArray  layout: layoutClass slots: slotDefinition classVariables: classVarDefinition poolDictionaries: someSharedPoolNames category: aCategorySymbol [
	^ self
		subclass: aSubclassSymbol
		uses: aTraitCompositionOrArray
		with: [ 
			self classInstaller
				make: [ :builder | 
					builder
						name: aSubclassSymbol;
						superclass: self;
						layoutClass: layoutClass;
						slots: slotDefinition;
						sharedVariables: classVarDefinition;
						sharedPools: someSharedPoolNames;
						category: aCategorySymbol ] ]
]

{ #category : #'*Traits' }
Class >> subclass: aSubclassSymbol uses: aTraitCompositionOrArray slots: slotDefinition classVariables: classVarDefinition category: aCategorySymbol [
	^ self
		subclass: aSubclassSymbol
		uses: aTraitCompositionOrArray
		with: [ 
			self classInstaller
				make: [ :builder | 
					builder
						name: aSubclassSymbol;
						superclass: self;
						slots: slotDefinition;
						sharedVariables: classVarDefinition;
						category: aCategorySymbol ] ]
]

{ #category : #'*Traits' }
Class >> subclass: aSubclassSymbol uses: aTraitCompositionOrArray slots: slotDefinition classVariables: classVarDefinition poolDictionaries: someSharedPoolNames category: aCategorySymbol [
	^ self
		subclass: aSubclassSymbol
		uses: aTraitCompositionOrArray
		with: [ 
			self classInstaller
				make: [ :builder | 
					builder
						name: aSubclassSymbol;
						superclass: self;
						slots: slotDefinition;
						sharedVariables: classVarDefinition;
						sharedPools: someSharedPoolNames;
						category: aCategorySymbol ] ]
]

{ #category : #'*Traits' }
Class >> subclass: aName uses: aTraitComposition with: aBlock [ 
	"Define (or redefine) a subclass by evaluating a block closure. 

	Note (MartinDias): 
		This is a workaround for the subclass creation API when a trait is specified. 
		To fix it well, in Pharo 4, a bit deeper refactoring is required, delegating this responsibility
		to SlotClassBuilder."

	^ self environment 
		at: aName
		ifPresent: [ :old | 
			| copyOfOld newClass |
			copyOfOld := old copy.

			"Modify the class and set the new trait composition"
			newClass := aBlock value. 
			newClass setTraitComposition: aTraitComposition asTraitComposition.

			"Announce that the definition changed when there is a new trait composution. 
			Note: It may be a re-announce if there was other change in the class definition, 
			e.g. an instace variable added."
			(newClass traitComposition syntacticallyEquals: copyOfOld traitComposition) ifFalse: [ 
				SystemAnnouncer uniqueInstance 
					classDefinitionChangedFrom: copyOfOld to: newClass;
					classModificationAppliedTo: newClass ].

			newClass ]
		ifAbsent: [ | newClass |
			"Create the class and set the trait composition"
			newClass := aBlock value.
			newClass setTraitComposition: aTraitComposition asTraitComposition.
			SystemAnnouncer uniqueInstance classModificationAppliedTo: newClass.
			newClass].
]

{ #category : #'*Traits' }
Class >> traitComposition [

	<localClassMethod> 
    "This method is supposed to be local in Class because of a good reason.
    We use this pragma to test if Class does not contain some accidental 
    local selectors."

	traitComposition ifNil: [traitComposition := TraitComposition new].
	^traitComposition
]

{ #category : #'*Traits' }
Class >> traitComposition: aTraitComposition [

	<localClassMethod> 
    "This method is supposed to be local in Class because of a good reason.
    We use this pragma to test if Class does not contain some accidental 
    local selectors."
	
	traitComposition := aTraitComposition
]

{ #category : #'*Traits' }
Class >> variableByteSubclass: className uses: aTraitCompositionOrArray instanceVariableNames: instVarNames 
	classVariableNames: classVarNames category: cat [
		"Added to allow for a simplified subclass creation experience. "
	
	^ self variableByteSubclass: className
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames
		classVariableNames: classVarNames 
		poolDictionaries: ''
		category: cat
]

{ #category : #'*Traits' }
Class >> variableByteSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames category: aCategory [
	"Creates a new class as a subclass of an existing class (the receiver) 
	in which the subclass is to have indexable byte-sized nonpointer variables."
	
	^ self
		subclass: aName
		uses: aTraitComposition
		with: [ 
			self
				variableByteSubclass: aName
				instanceVariableNames: someInstanceVariableNames
				classVariableNames: someClassVariableNames
				poolDictionaries: someSharedPoolNames
				category: aCategory ]
]

{ #category : #'*Traits' }
Class >> variableSubclass: aClassName uses: aTraitCompositionOrArray instanceVariableNames: instVarNames 
	classVariableNames: classVarNames category: cat [
	"Added to allow for a simplified subclass creation experience. "
	
	^ self variableSubclass: aClassName 
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames  
		classVariableNames: classVarNames 
		poolDictionaries: ''
		category: cat
]

{ #category : #'*Traits' }
Class >> variableSubclass: aClassName uses: aTraitCompositionOrArray instanceVariableNames: instVarNames classVariableNames: classVarNames package: cat [

	^ self variableSubclass: aClassName uses: aTraitCompositionOrArray instanceVariableNames: instVarNames classVariableNames: classVarNames category: cat

]

{ #category : #'*Traits' }
Class >> variableSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames category: aCategory [
	"Creates a new class as a subclass of an existing class (the receiver) 
	in which the subclass is to have indexable pointer variables."
	
	^ self
		subclass: aName
		uses: aTraitComposition
		with: [ 
			self
				variableSubclass: aName
				instanceVariableNames: someInstanceVariableNames
				classVariableNames: someClassVariableNames
				poolDictionaries: someSharedPoolNames
				category: aCategory ]
]

{ #category : #'*Traits' }
Class >> variableSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames package: aCategory [
	^ self variableSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames category: aCategory
]

{ #category : #'*Traits' }
Class >> variableWordSubclass: className uses: aTraitCompositionOrArray instanceVariableNames: instVarNames classVariableNames: classVarNames category: cat [
	"Added to allow for a simplified subclass creation experience. "

	^ self
		variableWordSubclass: className
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames
		classVariableNames: classVarNames
		package: cat
]

{ #category : #'*Traits' }
Class >> variableWordSubclass: className uses: aTraitCompositionOrArray instanceVariableNames: instVarNames
	classVariableNames: classVarNames package: cat [
	"Added to allow for a simplified subclass creation experience. "

	^ self variableWordSubclass: className
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames
		classVariableNames: classVarNames
		poolDictionaries: ''
		package: cat
]

{ #category : #'*Traits' }
Class >> variableWordSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames category: aCategory [
	^ self
		variableWordSubclass: aName
		uses: aTraitComposition
		instanceVariableNames: someInstanceVariableNames
		classVariableNames: someClassVariableNames
		poolDictionaries: someSharedPoolNames
		package: aCategory
]

{ #category : #'*Traits' }
Class >> variableWordSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames package: aCategory [
	"Creates a new class as a subclass of an existing class (the receiver) 
	in which the subclass is to have indexable word-sized nonpointer variables."
	
	^ self
		subclass: aName
		uses: aTraitComposition
		with: [ 
			self
				variableWordSubclass: aName
				instanceVariableNames: someInstanceVariableNames
				classVariableNames: someClassVariableNames
				poolDictionaries: someSharedPoolNames
				package: aCategory ]
]

{ #category : #'*Traits' }
Class >> weakSubclass: className uses: aTraitCompositionOrArray instanceVariableNames: instVarNames 
	classVariableNames: classVarNames category: cat [
	"Added to allow for a simplified subclass creation experience. "
	
	^ self weakSubclass: className
		uses: aTraitCompositionOrArray
		instanceVariableNames: instVarNames 
		classVariableNames: classVarNames 
		poolDictionaries: ''
		category: cat

]

{ #category : #'*Traits' }
Class >> weakSubclass: className uses: aTraitCompositionOrArray instanceVariableNames: instVarNames 
	classVariableNames: classVarNames package: cat [
	"Added to allow for a simplified subclass creation experience. "
	
	^self weakSubclass: className uses: aTraitCompositionOrArray instanceVariableNames: instVarNames classVariableNames: classVarNames category: cat
]

{ #category : #'*Traits' }
Class >> weakSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames category: aCategory [
	"Creates a new class as a subclass of an existing class (the receiver) 
	in which the subclass is to have weak indexable pointer variables."
	
	^ self
		subclass: aName
		uses: aTraitComposition
		with: [ 
			self
				weakSubclass: aName
				instanceVariableNames: someInstanceVariableNames
				classVariableNames: someClassVariableNames
				poolDictionaries: someSharedPoolNames
				category: aCategory ]
]

{ #category : #'*Traits' }
Class >> weakSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames package: aCategory [
	"Creates a new class as a subclass of an existing class (the receiver) 
	in which the subclass is to have weak indexable pointer variables."
	
	^self weakSubclass: aName uses: aTraitComposition instanceVariableNames: someInstanceVariableNames classVariableNames: someClassVariableNames poolDictionaries: someSharedPoolNames category: aCategory
]
