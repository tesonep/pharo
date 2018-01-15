Class {
	#name : #MetaclassForTraits,
	#superclass : #TraitedMetaclass,
	#instVars : [
		'users'
	],
	#category : #TraitsV2
}

{ #category : #users }
MetaclassForTraits >> addUser: aClass [ 
	
	users add: aClass
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

{ #category : #users }
MetaclassForTraits >> removeUser: aClass [

	users remove: aClass ifAbsent: [  ]
]

{ #category : #accessing }
MetaclassForTraits >> traitUsers [
	^ self users
]

{ #category : #accessing }
MetaclassForTraits >> users [
	^ users
]

{ #category : #accessing }
MetaclassForTraits >> users: anObject [
	users := anObject
]
