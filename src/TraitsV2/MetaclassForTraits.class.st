Class {
	#name : #MetaclassForTraits,
	#superclass : #TraitedMetaclass,
	#instVars : [
		'users'
	],
	#category : #TraitsV2
}

{ #category : #'accessing method dictionary' }
MetaclassForTraits >> addSelectorSilently: selector withMethod: compiledMethod [
	super addSelectorSilently: selector withMethod: compiledMethod.
	self rebuildMethodDictionary.
	
	self users do: [ :e | e rebuildMethodDictionary ]
]

{ #category : #users }
MetaclassForTraits >> addUser: aClass [ 
	
	self users add: aClass
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
