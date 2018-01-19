Class {
	#name : #MetaclassForTraits,
	#superclass : #TraitedMetaclass,
	#instVars : [
		'users'
	],
	#category : #TraitsV2
}

{ #category : #operations }
MetaclassForTraits >> + anotherTrait [
	
	^ self asTraitComposition + anotherTrait asTraitComposition
]

{ #category : #composition }
MetaclassForTraits >> @ anArray [
	^ self asTraitComposition @ anArray
]

{ #category : #users }
MetaclassForTraits >> addUser: aClass [ 
	
	self users add: aClass
]

{ #category : #converting }
MetaclassForTraits >> asTraitComposition [
	^ TaClassCompositionElement for: self
]

{ #category : #accessing }
MetaclassForTraits >> baseTrait [
	
	^ self baseClass 
]

{ #category : #'fileIn/Out' }
MetaclassForTraits >> definition [
	^ String streamContents: [ :s | 
		s 
			nextPutAll: self baseClass name;
			nextPutAll: ' classTrait';
			cr; tab;
			nextPutAll: 'uses: ';
			nextPutAll: composition traitCompositionExpression.
	]
]

{ #category : #testing }
MetaclassForTraits >> isBaseTrait [
	
	^ false
]

{ #category : #testing }
MetaclassForTraits >> isClassTrait [
	
	^ true
]

{ #category : #printing }
MetaclassForTraits >> printOn: aStream [
	aStream
		nextPutAll: self baseClass name;
		nextPutAll: ' classTrait'
]

{ #category : #initialization }
MetaclassForTraits >> rebuildMethodDictionary [
	super rebuildMethodDictionary.
	self users do: [ :e | e rebuildMethodDictionary ]

]

{ #category : #users }
MetaclassForTraits >> removeUser: aClass [
	
	self users remove: aClass ifAbsent: [  ]
]

{ #category : #accessing }
MetaclassForTraits >> traitUsers [
	^ self users
]

{ #category : #accessing }
MetaclassForTraits >> users [

	^ users ifNil: [ users := IdentitySet new ]
]

{ #category : #accessing }
MetaclassForTraits >> users: anObject [
	users := anObject
]
