Class {
	#name : #TraitedMetaclass,
	#superclass : #Metaclass,
	#instVars : [
		'localMethods',
		'composition'
	],
	#category : #TraitsV2
}

{ #category : #accessing }
TraitedMetaclass class >> traitedClassTrait [
	^ (TaCompositionElement for: TraitedClass)
]

{ #category : #'accessing method dictionary' }
TraitedMetaclass >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: category notifying: requestor [
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
TraitedMetaclass >> addSelector: selector withMethod: compiledMethod notifying: requestor [
	| r |
	r := super addSelector: selector withMethod: compiledMethod notifying: requestor.
	self rebuildMethodDictionary.
	^ r
]

{ #category : #querying }
TraitedMetaclass >> allTraits [
	
	^ self traitComposition allTraits
]

{ #category : #compiling }
TraitedMetaclass >> compile: selector from: oldClass [
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

{ #category : #testing }
TraitedMetaclass >> hasTraitComposition [
	
	^ self traitComposition isEmpty not
]

{ #category : #testing }
TraitedMetaclass >> includesLocalSelector: aSymbol [
	^ localMethods includesKey: aSymbol
]

{ #category : #initialization }
TraitedMetaclass >> initialize [
	super initialize.
	localMethods := MethodDictionary new.
	composition := TaEmptyComposition new.
]

{ #category : #'initialize-release' }
TraitedMetaclass >> instanceVariableNames: instVarString [ 
	
	^ self slots: instVarString asSlotCollection 
]

{ #category : #testing }
TraitedMetaclass >> isAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my or in another composition somewhere deeper in 
	the tree of traits compositions."

	^ self traitComposition isAliasSelector: aSymbol
]

{ #category : #testing }
TraitedMetaclass >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my trait composition."

	^ self traitComposition isLocalAliasSelector: aSymbol
]

{ #category : #testing }
TraitedMetaclass >> isLocalMethodsProtocol: aProtocol [
	aProtocol methods ifEmpty: [ ^true ].
	
	^aProtocol methods anySatisfy: [ :each | self isLocalSelector: each]
]

{ #category : #testing }
TraitedMetaclass >> isLocalSelector: aSelector [
	
	^ localMethods includesKey: aSelector
]

{ #category : #testing }
TraitedMetaclass >> isRejectedMethod: e [
	^ (localMethods includesKey: e) or: [ (superclass methodDict includesKey: e) and: [ (Class methodDict includesKey: e) not ] ]
]

{ #category : #accessing }
TraitedMetaclass >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses" 
	 
	^ localMethods values
]

{ #category : #accessing }
TraitedMetaclass >> localSelectors [
	
	^ localMethods keys
]

{ #category : #adding }
TraitedMetaclass >> new [
	| newClass |
	newClass := super new.
	^newClass.
]

{ #category : #testing }
TraitedMetaclass >> originOfMethod: aMethod [
	(localMethods includesKey: aMethod selector)
		ifTrue: [ ^ self ].

	^ (self traitComposition
		traitDefining: aMethod selector
		ifNone: [ self class traitedClassTrait traitDefining: aMethod selector ifNone: [ ^ self ] ]) innerClass
]

{ #category : #initialization }
TraitedMetaclass >> rebuildMethodDictionary [
	| selectors toUse removedSelectors |

	toUse := (superclass isKindOf: self class)
		ifTrue: [ self traitComposition ]
		ifFalse: [ self traitComposition + self class traitedClassTrait ].

	localMethods := MethodDictionary new.
	methodDict valuesDo: [ :m | (m propertyAt: #sourceTrait) ifNil: [ localMethods at: m selector put: m ]].

	selectors := toUse selectors reject: [ :e | self isRejectedMethod: e ].
	selectors do: [ :e | toUse compile: e into: self ].
	
	removedSelectors := methodDict keys reject: [ :aSelector | (selectors includes: aSelector) or: [ localMethods includesKey: aSelector] ].
	removedSelectors do: [ :aSelector | methodDict removeKey: aSelector ].

]

{ #category : #'accessing method dictionary' }
TraitedMetaclass >> removeSelector: aSelector [
	super removeSelector: aSelector.
	self rebuildMethodDictionary.
]

{ #category : #initialization }
TraitedMetaclass >> slots [

	^ super slots reject: [ :e | composition slots includes: e ]
]

{ #category : #'initialize-release' }
TraitedMetaclass >> slots: slotCollection [ 

	| theClass builderEnhancer |
	theClass := self theNonMetaClass.
		
	builderEnhancer := TraitBuilderEnhancer new.
	builderEnhancer traitComposition: theClass traitComposition asTraitComposition.
	builderEnhancer classTraitComposition: self traitComposition asTraitComposition.	
	
	theClass := theClass classInstaller update: theClass to: [ :builder |
		builder
			superclass: theClass superclass;
			builderEnhancer: builderEnhancer;
			metaclassClass: self class;
			name: theClass name;
			layoutClass: theClass classLayout class;
			slots: theClass slots;
			sharedVariablesFromString: theClass classVariablesString;
			sharedPools: theClass sharedPoolsString;
			traitComposition: theClass traitComposition;
			category: theClass category asString;
			classSlots: slotCollection ].
	^ theClass theMetaClass
]

{ #category : #'as yet unclassified' }
TraitedMetaclass >> slotsWithoutTraits [
	^ self slots reject: [ :e | TraitedClass slots anySatisfy: [ :x | x name = e name ] ] 
]

{ #category : #accessing }
TraitedMetaclass >> traitComposition [
	^ composition
]

{ #category : #accessing }
TraitedMetaclass >> traitComposition: aComposition [

	composition := aComposition
]

{ #category : #initialization }
TraitedMetaclass >> traits [
	^ composition traits
]
