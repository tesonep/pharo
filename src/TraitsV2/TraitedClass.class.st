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

{ #category : #adding }
TraitedClass >> addSelectorSilently: selector withMethod: compiledMethod [
	super addSelectorSilently: selector withMethod: compiledMethod.
	self rebuildMethodDictionary.
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

{ #category : #compiling }
TraitedClass >> compile: selector from: oldClass [
	"Compile the method associated with selector in the receiver's method dictionary."

	| method newMethod |
	method := oldClass compiledMethodAt: selector.
	newMethod := self compiler
				source: (oldClass sourceCodeAt: selector);
				class: self;
				failBlock: [^ self];
				compile.   "Assume OK after proceed from SyntaxError"
	selector == newMethod selector ifFalse: [self error: 'selector changed!'].
	self basicAddSelector: selector withMethod: newMethod.
]

{ #category : #initialization }
TraitedClass >> doRebuildMethodDictionary [
	| selectors |

	localMethods := MethodDictionary new.
	methodDict valuesDo: [ :m | (m propertyAt: #sourceTrait) ifNil: [ localMethods at: m selector put: m ]].

	selectors := composition selectors reject: [ :e | (localMethods includesKey: e) ].
	selectors do: [ :e | composition compile: e into: self ].

	self theMetaClass rebuildMethodDictionary
]

{ #category : #initialization }
TraitedClass >> initializeTraitedClass [
	localMethods := MethodDictionary new.
	composition := TaEmptyComposition new.
	
	self rebuildMethodDictionary.
]

{ #category : #'accessing method dictionary' }
TraitedClass >> localSelectors [
	
	^ localMethods keys
]

{ #category : #testing }
TraitedClass >> originOfMethod: aMethod [
	
	(localMethods includesKey: aMethod selector) 
		ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector) innerClass
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

{ #category : #initialization }
TraitedClass >> slots [
	^ super slots reject:[ :e  | composition slots includes:e ]
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
TraitedClass >> traits [
	^ self traitComposition traits.
]
