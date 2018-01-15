Class {
	#name : #Trait,
	#superclass : #Object,
	#classInstVars : [
		'users'
	],
	#category : #TraitsV2
}

{ #category : #accessing }
Trait class >> + anotherTrait [
	^ self asTraitComposition + anotherTrait asTraitComposition
]

{ #category : #accessing }
Trait class >> - anArray [
	^ self asTraitComposition - anArray
]

{ #category : #accessing }
Trait class >> @ anArray [
	^ self asTraitComposition @ anArray
]

{ #category : #users }
Trait class >> addUser: aClass [ 

	users add: aClass
]

{ #category : #'class variables' }
Trait class >> allClassVarNames [
	
	^ #()
]

{ #category : #accessing }
Trait class >> asTraitComposition [
	^ TaCompositionElement for: self.
]

{ #category : #'filein/out' }
Trait class >> definition [
	
	(self baseClass name == #Trait) ifTrue: [ ^ super definition ].

	^ String streamContents: [ :s | 
		s 
			nextPutAll: 'Trait named: ';
			nextPutAll:	self name printString;
			cr; tab;
			nextPutAll: ' uses: ';
			nextPutAll: self traitComposition traitCompositionExpression;
			cr; tab;
			nextPutAll: ' category: ';
			nextPutAll: self category asString printString
	]
]

{ #category : #'filein/out' }
Trait class >> definitionForNautilus [

	^ self definition
]

{ #category : #'filein/out' }
Trait class >> definitionForNautilusWithSlots [

	^ self definition
]

{ #category : #testing }
Trait class >> isTrait [
	^ true
]

{ #category : #'instance creation' }
Trait class >> named: aSymbol [
	^ self named: aSymbol uses: {} category: 'Unclassified'
]

{ #category : #'instance creation' }
Trait class >> named: aSymbol uses: aCompositionOrArray [
	^ self named: aSymbol uses: aCompositionOrArray category: 'Unclassified'
]

{ #category : #'instance creation' }
Trait class >> named: aSymbol uses: aTraitCompositionOrCollection category: aString [
	^ self
		named: aSymbol
		uses: aTraitCompositionOrCollection
		category: aString
		env: self environment
]

{ #category : #'instance creation' }
Trait class >> named: aName uses: aTraitCompositionOrCollection category: aString env: anEnvironment [
	^ self
		named: aName
		uses: aTraitCompositionOrCollection
		slots: #()
		category: aString
		env: anEnvironment
]

{ #category : #'instance creation' }
Trait class >> named: aName uses: aTraitCompositionOrCollection slots: someSlots category: aCategory env: anEnvironment [ 

	| trait builderEnhancer |
	builderEnhancer := TraitBuilderEnhancer new.
	builderEnhancer traitComposition: aTraitCompositionOrCollection asTraitComposition.
	builderEnhancer classTraitComposition: aTraitCompositionOrCollection asTraitComposition classComposition.
	
	trait:= self classInstaller
		make: [ :builder | 
			builder
				metaclassClass: MetaclassForTraits;
				builderEnhancer: builderEnhancer;
				name: aName;
				superclass: self;
				slots: someSlots;
				sharedVariables: '';
				sharedPools: '';
				category: aCategory;
				classSlots: #() ].
		
	trait users: IdentitySet new.
	trait class users: IdentitySet new.
	^ trait
]

{ #category : #users }
Trait class >> removeUser: aClass [ 
	users ifNil: [ users := IdentitySet new ].
	users remove: aClass ifAbsent: [ ].
	
	
]

{ #category : #accessing }
Trait class >> traitUsers [
	^ self users
]

{ #category : #accessing }
Trait class >> users [
	^ users
]

{ #category : #accessing }
Trait class >> users: anObject [
	users := anObject
]
