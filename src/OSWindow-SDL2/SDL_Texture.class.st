"
I represent a handle of GL texture, coming from SDL2 library
"
Class {
	#name : #'SDL_Texture',
	#superclass : #SDL2Handle,
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #finalization }
SDL_Texture class >> destroyTexture: aHandle [
	^ self ffiCall: #( void SDL_DestroyTexture ( void *aHandle ) )
]

{ #category : #finalization }
SDL_Texture class >> finalizeResourceData: aHandle [
	aHandle isNull ifTrue: [ ^ self ].
	self destroyTexture: aHandle.
	aHandle beNull	
]

{ #category : #initialization }
SDL_Texture >> destroy [
	handle isNull ifTrue: [ ^ self ].
	SDL2Library defer: [ self ffiDestroy ].
	handle beNull
]

{ #category : #private }
SDL_Texture >> ffiDestroy [
	^ self ffiCall: #( void SDL_DestroyTexture ( self ) )
]

{ #category : #'pixels handling' }
SDL_Texture >> ffiLockPixels: pixels pitch: pitch [
	^ self ffiCall: #( int SDL_LockTexture ( self , nil , void** pixels , int* pitch ) )
]

{ #category : #'pixels handling' }
SDL_Texture >> ffiUnlock [
	^ self ffiCall: #( void SDL_UnlockTexture ( self ) )
]

{ #category : #initialization }
SDL_Texture >> ffiUpdateTexturePixels: pixels pitch: pitch [
	^ self ffiCall: #( int SDL_UpdateTexture ( self , nil , void* pixels , int pitch ) )
]

{ #category : #initialization }
SDL_Texture >> ffiUpdateTextureRect: rect pixels: pixels pitch: pitch [
	^ self ffiCall: #( int SDL_UpdateTexture ( self , SDL_Rect* rect , void* pixels , int pitch ) )
]

{ #category : #initialization }
SDL_Texture >> initialize [
	self autoRelease
]

{ #category : #'pixels handling' }
SDL_Texture >> lockPixels: pixels pitch: pitch [
	
	^ SDL2Library defer: [ self ffiLockPixels: pixels pitch: pitch ]
]

{ #category : #'pixels handling' }
SDL_Texture >> unlock [
	
	^ SDL2Library defer: [ self ffiUnlock ]
]

{ #category : #initialization }
SDL_Texture >> updateTexturePixels: pixels pitch: pitch [

	^ SDL2Library defer: [ self ffiUpdateTexturePixels: pixels pitch: pitch ]
]

{ #category : #initialization }
SDL_Texture >> updateTextureRect: rect pixels: pixels pitch: pitch [

	^ SDL2Library defer: [ self ffiUpdateTextureRect: rect pixels: pixels pitch: pitch ]

]
