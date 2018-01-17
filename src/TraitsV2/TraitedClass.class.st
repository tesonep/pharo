Class {
	#name : #TraitedClass,
	#superclass : #Object,
	#instVars : [
		'methodDict',
		'localMethods',
		'composition'
	],
	#category : #TraitsV2
}

{ #category : #accessing }
TraitedClass class >> traitComposition [
	
	^ TaEmptyComposition new
]

{ #category : #'accessing method dictionary' }
TraitedClass >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: category notifying: requestor [
	| r |
	r := super
		addAndClassifySelector: selector
		withMethod: compiledMethod
		inProtocol: category
		notifying: requestor.

	self rebuildMethodDictionary.
	^ r
	
]

{ #category : #'accessing method dictionary' }
TraitedClass >> addSelector: selector withMethod: compiledMethod notifying: requestor [
	| r |
	r := super addSelector: selector withMethod: compiledMethod notifying: requestor.
	self rebuildMethodDictionary.
	^ r
]

{ #category : #adding }
TraitedClass >> addSlot: aSlot [

	| builderEnhancer |
	builderEnhancer := TraitBuilderEnhancer new.
	builderEnhancer traitComposition: self traitComposition asTraitComposition.
	builderEnhancer classTraitComposition: self class traitComposition asTraitComposition.

	^self classInstaller update: self to: [ :builder |
		builder
			superclass: self superclass;
			builderEnhancer: builderEnhancer;
			metaclassClass: self class class;
			name: self getName;
			layoutClass: self classLayout class;
			slots: (self slots copyWith: aSlot);
			classSlots: self class classLayout slots;
			sharedVariablesFromString: self classVariablesString;
			sharedPools: self sharedPoolsString;
			category: self category;
			environment: self environment].
]

{ #category : #querying }
TraitedClass >> allTraits [
	
	^ self traitComposition allTraits
]

{ #category : #compiling }
TraitedClass >> compile: selector from: oldClass [
	"Compile the method associated with selector in the receiver's method dictionary."

	| method newMethod sourceCode trailer |
	method := oldClass compiledMethodAt: selector.
	sourceCode := oldClass sourceCodeAt: selector.
	trailer := method trailer.
	
	(trailer sourceCode = sourceCode) ifFalse: [ trailer sourceCode: sourceCode  ].

	newMethod := self compiler
				source: sourceCode;
				class: self;
				failBlock: [^ self];
				compiledMethodTrailer: trailer;
				compile.   "Assume OK after proceed from SyntaxError"
	selector == newMethod selector ifFalse: [self error: 'selector changed!'].
		
	self basicAddSelector: selector withMethod: newMethod.

	self organization protocolOrganizer
		classify: selector
		inProtocolNamed: method category.		

]

{ #category : #initialization }
TraitedClass >> doRebuildMethodDictionary [
	| selectors removedSelectors |

	localMethods := MethodDictionary new.
	methodDict valuesDo: [ :m | (m propertyAt: #sourceTrait) ifNil: [ localMethods at: m selector put: m ]].

	selectors := composition selectors reject: [ :e | (localMethods includesKey: e) ].
	selectors do: [ :e | composition compile: e into: self ].

	removedSelectors := methodDict keys reject: [ :aSelector | (selectors includes: aSelector) or: [ localMethods includesKey: aSelector] ].
	removedSelectors do: [ :aSelector | methodDict removeKey: aSelector ].

	self theMetaClass rebuildMethodDictionary
]

{ #category : #testing }
TraitedClass >> hasTraitComposition [
	
	^ self traitComposition isEmpty not
]

{ #category : #testing }
TraitedClass >> includesLocalSelector: aSymbol [
	^ localMethods includesKey: aSymbol
]

{ #category : #initialization }
TraitedClass >> initializeTraitedClass [
	localMethods := MethodDictionary new.
	composition := TaEmptyComposition new.
	
	self rebuildMethodDictionary.
]

{ #category : #testing }
TraitedClass >> isAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my or in another composition somewhere deeper in 
	the tree of traits compositions."

	^ self traitComposition isAliasSelector: aSymbol
]

{ #category : #testing }
TraitedClass >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my trait composition."

	^ self traitComposition isLocalAliasSelector: aSymbol
]

{ #category : #testing }
TraitedClass >> isLocalMethodsProtocol: aProtocol [
	aProtocol methods ifEmpty: [ ^true ].
	
	^aProtocol methods anySatisfy: [ :each | self isLocalSelector: each]
]

{ #category : #testing }
TraitedClass >> isLocalSelector: aSelector [
	
	^ localMethods includesKey: aSelector
]

{ #category : #accessing }
TraitedClass >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses" 
	 
	^ localMethods values
]

{ #category : #'accessing method dictionary' }
TraitedClass >> localSelectors [
	
	^ localMethods keys
]

{ #category : #testing }
TraitedClass >> originOfMethod: aMethod [
	(localMethods includesKey: aMethod selector)
		ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ ^ self ]) innerClass
]

{ #category : #initialization }
TraitedClass >> rebuildMethodDictionary [

	"Useful to be rewritten in Traits"
	self doRebuildMethodDictionary.

]

{ #category : #'trait-composition' }
TraitedClass >> recreateWithoutComposition [
	
	^ self classInstaller
		make: [ :builder | 
			builder
				name: self name;
				superclass: self superclass;
				slots: self slots;
				sharedVariables: self classVariablesString;
				sharedPools: self sharedPoolsString;
				category: self category;
				copyClassSlotsFromExistingClass ]	
]

{ #category : #'trait-composition' }
TraitedClass >> removeFromComposition: aTrait [

	self setTraitComposition: (composition copyWithoutTrait: aTrait asTraitComposition)
]

{ #category : #removing }
TraitedClass >> removeSelector: aSelector [
	super removeSelector: aSelector.	
	self rebuildMethodDictionary.
]

{ #category : #removing }
TraitedClass >> removeSlot: aSlot [ 

	| builderEnhancer |
	
	(self classLayout slots includes: aSlot)
		ifFalse: [self error: aSlot name , ' is not one of my slots'].
		
	builderEnhancer := TraitBuilderEnhancer new.
	builderEnhancer traitComposition: self traitComposition asTraitComposition.
	builderEnhancer classTraitComposition: self class traitComposition asTraitComposition.

	^self classInstaller update: self to: [ :builder |
		builder
			superclass: self superclass;
			builderEnhancer: builderEnhancer;
			metaclassClass: self class class;
			name: self name;
			layoutClass: self classLayout class;
			slots: (self classLayout slots copyWithout: aSlot);
			classSlots: self class classLayout slots;
			sharedVariablesFromString: self classVariablesString;
			sharedPools: self sharedPoolsString;
			category: self category;
			environment: self environment]
	
]

{ #category : #initialization }
TraitedClass >> slots [
	^ super slots reject:[ :e  | composition slots includes:e ]
]

{ #category : #'accessing tags' }
TraitedClass >> tagsForMethods [
	"Any method could be tagged with multiple symbols for user purpose. 
	And class contains all method tags which used or not used yet by methods.
	For now we could only implemented it on top of Protocol. 
	It supposed to not include any method tags inherited from Traits 
	which is opposite to current Protocol implementation.
	And extension protocol is not treated as tag"
	| allProtocols tags |
	allProtocols := self organization protocols 
		reject: [ :each | each name = Protocol unclassified | each isExtensionProtocol ].
		
	tags := OrderedCollection new.
	allProtocols do: [ :each | 
		(self isLocalMethodsProtocol: each) ifTrue: [ tags add: each name ]].

	^tags
]

{ #category : #accessing }
TraitedClass >> traitComposition [

	^ composition
]

{ #category : #accessing }
TraitedClass >> traitComposition: anObject [
	composition := anObject
]

{ #category : #accessing }
TraitedClass >> traitCompositionString [
	^ self traitComposition asString
]

{ #category : #accessing }
TraitedClass >> traits [
	^ self traitComposition traits.
]
