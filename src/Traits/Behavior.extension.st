Extension { #name : #Behavior }

{ #category : #'*Traits' }
Behavior >> addExclusionOf: aSymbol to: aTrait [
	self setTraitComposition: (
		self traitComposition copyWithExclusionOf: aSymbol to: aTrait)
]

{ #category : #'*Traits' }
Behavior >> addToComposition: aTrait [
	self setTraitComposition: (self traitComposition copyTraitExpression
		add: aTrait;
		yourself)
]

{ #category : #'*Traits' }
Behavior >> addTraitSelector: aSymbol withMethod: aCompiledMethod [
	"Add aMethod with selector aSymbol to my
	methodDict. aMethod must not be defined locally."

	| source method |
	[(self includesLocalSelector: aSymbol) not] assert.
	self ensureLocalSelectors.
		
	source := aCompiledMethod getSourceReplacingSelectorWith: aSymbol.
	method  := aCompiledMethod copy.
	method selector: aSymbol.
	method methodClass: self.
		
	"write source to changes file only if we have it (not available during bootstrap)"	
	((Smalltalk globals includesKey: #SourceFiles) and: [ (Smalltalk globals at: #SourceFiles) notNil]) ifTrue: [ 
		method putSource: source
			withPreamble: [:f | f cr; nextPut: $!; nextChunkPut: 'Trait method'; cr]].
	
	method properties at: #traitSource put: aCompiledMethod.
	
	self basicAddSelector: aSymbol withMethod: method
]

{ #category : #'*Traits' }
Behavior >> addUser: aClassOrTrait [
	self traitUsers add: aClassOrTrait.
]

{ #category : #'*Traits' }
Behavior >> applyChangesOfNewTraitCompositionReplacing: oldComposition [
	| changedSelectors |
	changedSelectors := self traitComposition
		changedSelectorsComparedTo: oldComposition.
	changedSelectors isEmpty ifFalse: [
		self noteChangedSelectors: changedSelectors].
	self traitComposition isEmpty ifTrue: [
		self purgeLocalSelectors].
	^changedSelectors
]

{ #category : #'*Traits' }
Behavior >> classesComposedWithMe [
	self isTrait
		ifTrue: [ ^ self traitUsers flatCollect: [ :u | u classesComposedWithMe ] ]
		ifFalse: [ ^ {self} ]
]

{ #category : #'*Traits' }
Behavior >> ensureLocalSelectors [
	"Ensures that the instance variable localSelectors is effectively used to maintain
	the set of local selectors.
	This method must be called before any non-local selectors are added to the
	method dictionary!"

	self basicLocalSelectors ifNil: [self basicLocalSelectors: self selectors asSet]
]

{ #category : #'*Traits' }
Behavior >> flattenDown: aTrait [
| selectors |
	[self hasTraitComposition and: [self traitComposition allTraits includes: aTrait]] assert.
	(self traitComposition transformationOfTrait: aTrait)
		ifNotNil: [ :transformation | 
			selectors := transformation selectors.
	self basicLocalSelectors: (self basicLocalSelectors ifNil: Array new) asArray , selectors.
	self removeFromComposition: aTrait. ].
]

{ #category : #'*Traits' }
Behavior >> flattenDownAllTraits [
	self traitComposition allTraits do: [:each | self flattenDown: each].
	[ self traitComposition isEmpty ] assert.
	self traitComposition: nil.
]

{ #category : #'*Traits' }
Behavior >> hasTraitComposition [

	^ self traitComposition notEmpty.
]

{ #category : #'*Traits' }
Behavior >> noteChangedSelectors: aCollection [
	"Start update of my methodDict (after changes to traits in traitComposition
	or after a local method was removed from my methodDict). The argument 
	is a collection of method selectors that may have been changed. Most of the time
	aCollection only holds one selector. But when there are aliases involved 
	there may be several method changes that have to be propagated to users."

	| affectedSelectors |
	affectedSelectors := IdentitySet new.
	aCollection do: [:selector |
		affectedSelectors addAll: (self updateMethodDictionarySelector: selector)].
	self notifyUsersOfChangedSelectors: affectedSelectors.
	^ affectedSelectors
]

{ #category : #'*Traits' }
Behavior >> notifyUsersOfChangedSelector: aSelector [
	self notifyUsersOfChangedSelectors: (Array with: aSelector)
]

{ #category : #'*Traits' }
Behavior >> notifyUsersOfChangedSelectors: aCollection [
]

{ #category : #'*Traits' }
Behavior >> purgeLocalSelectors [
	self basicLocalSelectors: nil
]

{ #category : #'*Traits' }
Behavior >> removeAlias: aSymbol of: aTrait [
	self setTraitComposition: (
		self traitComposition copyWithoutAlias: aSymbol of: aTrait)
]

{ #category : #'*Traits' }
Behavior >> removeFromComposition: aTrait [
	self setTraitComposition: (self traitComposition copyTraitExpression
		removeFromComposition: aTrait)
]

{ #category : #'*Traits' }
Behavior >> removeTraitSelector: aSymbol [
	[(self includesLocalSelector: aSymbol) not] assert.
	self basicRemoveSelector: aSymbol
]

{ #category : #'*Traits' }
Behavior >> removeUser: aClassOrTrait [
	self traitUsers remove: aClassOrTrait ifAbsent: []
]

{ #category : #'*Traits' }
Behavior >> setTraitComposition: aTraitComposition [
	| oldComposition |
	(self hasTraitComposition not and: [aTraitComposition isEmpty]) ifTrue: [^self].
	aTraitComposition assertValidUser: self.

	oldComposition := self traitComposition.
	self traitComposition: aTraitComposition.
	self applyChangesOfNewTraitCompositionReplacing: oldComposition.
	
	oldComposition traits do: [:each | each removeUser: self].
	aTraitComposition traits do: [:each | each addUser: self]
]

{ #category : #'*Traits' }
Behavior >> setTraitCompositionFrom: aTraitExpression [
	^ self setTraitComposition: aTraitExpression asTraitComposition
]

{ #category : #'*Traits' }
Behavior >> traitComposition [
	self subclassResponsibility
]

{ #category : #'*Traits' }
Behavior >> traitComposition: aTraitComposition [
	"Compatibility purposes"
]

{ #category : #'*Traits' }
Behavior >> traitCompositionIncludes: aTrait [
	^self == aTrait or: 
		[self hasTraitComposition and: 
			[self traitComposition allTraits includes: aTrait]]
]

{ #category : #'*Traits' }
Behavior >> traitCompositionString [
	^self hasTraitComposition
		ifTrue: [self traitComposition asString]
		ifFalse: ['{}']
]

{ #category : #'*Traits' }
Behavior >> traitOrClassOfSelector: aSymbol [
	"Return the trait or the class which originally defines the method aSymbol
	or return self if locally defined or if it is a conflict marker method.
	This is primarly used by Debugger to determin the behavior in which a recompiled
	method should be put. If a conflict method is recompiled it should be put into
	the class, thus return self. Also see TraitComposition>>traitProvidingSelector:"
	
	((self includesLocalSelector: aSymbol) or: [
		self hasTraitComposition not]) ifTrue: [^self].
	^(self traitComposition traitProvidingSelector: aSymbol) ifNil: [self]
]

{ #category : #'*Traits' }
Behavior >> traitTransformations [ 
	^ self traitComposition transformations 
]

{ #category : #'*Traits' }
Behavior >> traitUsers [
	"Compatibility purposes"
	^IdentitySet new.
]

{ #category : #'*Traits' }
Behavior >> traitUsers: aCollection [
	"Compatibility purposes"
]

{ #category : #'*Traits' }
Behavior >> traits [
	"Returns a collection of all traits used by the receiver"
	^ self traitComposition traits
]

{ #category : #'*Traits' }
Behavior >> traitsProvidingSelector: aSymbol [
	| result |
	result := OrderedCollection new.
	self hasTraitComposition ifFalse: [^result].
	(self traitComposition methodDescriptionsForSelector: aSymbol)
		do: [:methodDescription | methodDescription selector = aSymbol ifTrue: [
			result addAll: (methodDescription locatedMethods
				collect: [:each | each methodClass])]].
	^result
]

{ #category : #'*Traits' }
Behavior >> updateMethodDictionarySelector: aSymbol [
	"A method with selector aSymbol in myself or my traitComposition has been changed.
	Do the appropriate update to my methodDict (remove or update method) and
	return all affected selectors of me so that my useres get notified."

	| modifiedSelectors descriptions oldProtocol |
	modifiedSelectors := IdentitySet new.
	descriptions := self traitComposition methodDescriptionsForSelector: aSymbol.
	descriptions do: [:methodDescription | | effectiveMethod selector |
		selector := methodDescription selector.
		(self includesLocalSelector: selector) ifFalse: [
			methodDescription isEmpty
				ifTrue: [
					self removeTraitSelector: selector.
					modifiedSelectors add: selector]
				ifFalse: [
					effectiveMethod := methodDescription effectiveMethod.
					self addTraitSelector: selector withMethod: effectiveMethod.
					
					"If the method was not categorized yet, we categorize it "
					oldProtocol := self organization categoryOfElement: selector.
					(oldProtocol isNil or: [ oldProtocol = Protocol unclassified ]) 
						ifTrue: [ self organization classify: selector under: methodDescription effectiveMethodCategory. ].
					
					modifiedSelectors add: selector]]].
	^modifiedSelectors
]

{ #category : #'*Traits' }
Behavior >> users [
	"Compatibility purposes"
	^IdentitySet new.
]

{ #category : #'*Traits' }
Behavior >> users: aCollection [
	"Compatibility purposes"
]
