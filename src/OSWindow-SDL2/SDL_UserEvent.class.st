Class {
	#name : #'SDL_UserEvent',
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_CODE',
		'OFFSET_DATA1',
		'OFFSET_DATA2',
		'OFFSET_TIMESTAMP',
		'OFFSET_TYPE',
		'OFFSET_WINDOWID'
	],
	#pools : [
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #'field definition' }
SDL_UserEvent class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
    Uint32 type;
    Uint32 timestamp;
    Uint32 windowID;
    Sint32 code;
    void* data1;
    void* data2)
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> code [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_CODE
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> code: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_CODE put: anObject
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> data1 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA1) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> data1: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA1 put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> data2 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA2) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> data2: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA2 put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> timestamp [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_TIMESTAMP
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> timestamp: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_TIMESTAMP put: anObject
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> type [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_TYPE
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> type: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_TYPE put: anObject
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> windowID [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_WINDOWID
]

{ #category : #'accessing structure variables' }
SDL_UserEvent >> windowID: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_WINDOWID put: anObject
]
