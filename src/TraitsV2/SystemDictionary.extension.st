Extension { #name : #SystemDictionary }

{ #category : #'*TraitsV2' }
SystemDictionary >> allClassesAndTraits [
	"Return all the classes and traits defined in the Smalltalk SystemDictionary"

	^ self classAndTraitNames collect: [:each | self at: each]
]

{ #category : #'*TraitsV2' }
SystemDictionary >> allClassesAndTraitsDo: aBlock [
	"Evaluate the argument, aBlock, for each class and trait in the system."
	
	^self classAndTraitNames do: [:each | aBlock value: (self at: each)]
	
	

]

{ #category : #'*TraitsV2' }
SystemDictionary >> allTraits [
	"Return all traits defined in the Smalltalk SystemDictionary"

	^ self traitNames collect: [:each | self at: each]
]

{ #category : #'*TraitsV2' }
SystemDictionary >> allTraitsDo: aBlock [
	"Evaluate the argument, aBlock, for each trait in the system."

	^self traitNames do: [:name | aBlock value: (self at: name)]
]

{ #category : #'*TraitsV2' }
SystemDictionary >> classAndTraitNames [
	"Answer a sorted collection of all class and trait (not including class-traits) names. Do not bother to sort"

	
	^self classNames, self traitNames
	
]

{ #category : #'*TraitsV2' }
SystemDictionary >> traitNames [
	"Answer a SortedCollection of all traits (not including class-traits) names."
	
	^self classNames select: [ :name |
			self
				at: name
				ifPresent: [ :global | (global isTrait) and: [global isObsolete not]]
				ifAbsent: [ false ] ]
]
