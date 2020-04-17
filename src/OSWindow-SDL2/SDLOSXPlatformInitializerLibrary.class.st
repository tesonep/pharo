Class {
	#name : #SDLOSXPlatformInitializerLibrary,
	#superclass : #FFILibrary,
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #converting }
SDLOSXPlatformInitializerLibrary >> calloutAPIClass [

	^ TFCalloutAPI 
]

{ #category : #converting }
SDLOSXPlatformInitializerLibrary >> macLibraryName [ 

	^ 'libobjc.dylib'
]

{ #category : #converting }
SDLOSXPlatformInitializerLibrary >> runner [

	^ Smalltalk vm isAIOInterrupt 
		ifTrue: [ TFMainThreadRunner uniqueInstance ]
		ifFalse: [ TFSameThreadRunner uniqueInstance ]
]
