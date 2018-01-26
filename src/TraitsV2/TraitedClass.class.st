Class {
	#name : #TraitedClass,
	#superclass : #Object,
	#category : #TraitsV2
}

{ #category : #accessing }
TraitedClass class >> isTrait [
	^ true
]

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

	TraitChange addSelector: selector on: self.
	^ r
	
]

{ #category : #'accessing method dictionary' }
TraitedClass >> addSelector: selector withMethod: compiledMethod notifying: requestor [
	| r |
	r := super addSelector: selector withMethod: compiledMethod notifying: requestor.
	TraitChange addSelector: selector on: self..
	^ r
]

{ #category : #adding }
TraitedClass >> addSlot: aSlot [

	^self classInstaller update: self to: [ :builder |
		builder
			fillFor: self;
			slots: (self slots copyWith: aSlot)].
]

{ #category : #querying }
TraitedClass >> allTraits [
	
	^ self traitComposition allTraits
]

{ #category : #initialization }
TraitedClass >> doRebuildMethodDictionary [
	| selectors removedSelectors |

	self localMethodDict: MethodDictionary new.
	self methodDict valuesDo: [ :m | (m propertyAt: #sourceTrait) ifNil: [ self localMethodDict at: m selector put: m ]].

	selectors := self traitComposition selectors reject: [ :e | (self localMethodDict includesKey: e) ].
	selectors do: [ :e | self traitComposition installSelector: e into: self ].

	removedSelectors := self methodDict keys reject: [ :aSelector | (selectors includes: aSelector) or: [ self localMethodDict includesKey: aSelector] ].
	removedSelectors do: [ :aSelector | self methodDict removeKey: aSelector ].

	self theMetaClass rebuildMethodDictionary
]

{ #category : #testing }
TraitedClass >> hasTraitComposition [
	
	^ self traitComposition isEmpty not
]

{ #category : #testing }
TraitedClass >> includesLocalSelector: aSymbol [
	^ self localMethodDict includesKey: aSymbol
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
	
	^ self localMethodDict includesKey: aSelector
]

{ #category : #accessing }
TraitedClass >> localMethodDict [
	^ self class baseLocalMethods
]

{ #category : #accessing }
TraitedClass >> localMethodDict: aMethodDictionary [
	^ self class baseLocalMethods: aMethodDictionary 
]

{ #category : #accessing }
TraitedClass >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses" 
	 
	^ self localMethodDict values
]

{ #category : #'accessing method dictionary' }
TraitedClass >> localSelectors [
	
	^ self localMethodDict keys
]

{ #category : #testing }
TraitedClass >> originMethod: aMethod [
	(self localMethodDict includesKey: aMethod selector)
		ifTrue: [ ^ self localMethodDict at: aMethod selector ].

	^ [ self traitComposition compiledMethodAt: aMethod selector ]
		on: NotFound
		do: [ aMethod ]
]

{ #category : #testing }
TraitedClass >> originOfMethod: aMethod [
	(self localMethodDict includesKey: aMethod selector)
		ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ ^ self ]) innerClass
]

{ #category : #initialization }
TraitedClass >> rebuildMethodDictionary [

	"Useful to be rewritten in Traits"
	self doRebuildMethodDictionary.

]

{ #category : #'trait-composition' }
TraitedClass >> removeFromComposition: aTrait [

	self setTraitComposition: (self traitComposition copyWithoutTrait: aTrait asTraitComposition)
]

{ #category : #removing }
TraitedClass >> removeSelector: aSelector [
	super removeSelector: aSelector.	
	TraitChange removeSelector: aSelector on: self.
]

{ #category : #removing }
TraitedClass >> removeSlot: aSlot [ 
	
	(self classLayout slots includes: aSlot)
		ifFalse: [self error: aSlot name , ' is not one of my slots'].
		
	^self classInstaller update: self to: [ :builder |
		builder
			fillFor: self;
			slots: (self classLayout slots copyWithout: aSlot)]
	
]

{ #category : #initialization }
TraitedClass >> slots [
	^ super slots reject:[ :e  | self traitComposition slots includes:e ]
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

	^ self class baseComposition
]

{ #category : #accessing }
TraitedClass >> traitComposition: anObject [
	
	self class baseComposition: anObject
]

{ #category : #accessing }
TraitedClass >> traitCompositionString [
	^ self traitComposition asString
]

{ #category : #accessing }
TraitedClass >> traitUsers [
	
	^ #()
]

{ #category : #accessing }
TraitedClass >> traits [
	^ self traitComposition traits.
]
