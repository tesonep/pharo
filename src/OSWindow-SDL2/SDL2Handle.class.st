"
My subclasses represent various handles coming from SDL2 library
"
Class {
	#name : #SDL2Handle,
	#superclass : #FFIExternalObject,
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #accessing }
SDL2Handle class >> ffiLibrary [
	^ SDL2Library
]

{ #category : #resources }
SDL2Handle >> ffiLibrary [ 
	
	^ SDL2Library
]
