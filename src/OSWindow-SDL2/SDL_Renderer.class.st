"
I represent a handle of SDL rendering context, coming from SDL2 library
"
Class {
	#name : #'SDL_Renderer',
	#superclass : #SDL2Handle,
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #finalization }
SDL_Renderer class >> destroyRenderer: aHandle [
	^ self ffiCall: #( void SDL_DestroyRenderer ( void *aHandle ) )
]

{ #category : #finalization }
SDL_Renderer class >> finalizeResourceData: aHandle [
	aHandle isNull ifTrue: [ ^ self ].
	self destroyRenderer: aHandle.
	aHandle beNull
]

{ #category : #rendering }
SDL_Renderer >> clear [
	^ SDL2Library defer: [ self ffiClear ]
]

{ #category : #rendering }
SDL_Renderer >> copy: texture [

	^ SDL2Library defer: [ self ffiCopy: texture ]

]

{ #category : #rendering }
SDL_Renderer >> copy: texture srcRect: srcRect dstRect: dstRect [
	
	^ SDL2Library defer: [ self ffiCopy: texture srcRect: srcRect dstRect: dstRect ]

]

{ #category : #rendering }
SDL_Renderer >> createTextureFormat: format access: access width: width height: height [

	^ (SDL2Library
		defer: [ self
				ffiCreateTextureFormat: format
				access: access
				width: width
				height: height ]) initialize
]

{ #category : #initialization }
SDL_Renderer >> destroy [
	handle isNull ifTrue: [ ^ self ].
	SDL2Library defer: [ self ffiDestroy ]
	handle beNull
]

{ #category : #rendering }
SDL_Renderer >> drawColorR: r g: g b: b a: a [

	^ SDL2Library defer: [ self ffiDrawColorR: r g: g b: b a: a ]

]

{ #category : #rendering }
SDL_Renderer >> drawLineX1: x1 y1: y1 x2: x2 y2: y2 [

	^ SDL2Library defer: [ self ffiDrawLineX1: x1 y1: y1 x2: x2 y2: y2 ]

]

{ #category : #rendering }
SDL_Renderer >> drawPointX: x y: y [

	^ SDL2Library defer: [ self ffiDrawPointX: x y: y ]

]

{ #category : #rendering }
SDL_Renderer >> drawRect: rect [

	^ SDL2Library defer: [ self ffiDrawRect: rect ]

]

{ #category : #rendering }
SDL_Renderer >> ffiClear [
	^ self ffiCall: #( int SDL_RenderClear ( self ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiCopy: texture [
	^ self ffiCall: #( int SDL_RenderCopy ( self , SDL_Texture texture , nil, nil ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiCopy: texture srcRect: srcRect dstRect: dstRect [
	^ self ffiCall: #( int SDL_RenderCopy ( self , SDL_Texture texture , SDL_Rect* srcRect , SDL_Rect* dstRect ) )
]

{ #category : #private }
SDL_Renderer >> ffiCreateTextureFormat: format access: access width: width height: height [
	^ self ffiCall: #( SDL_Texture SDL_CreateTexture ( self , Uint32 format , int access , int width , int height ) )
]

{ #category : #initialization }
SDL_Renderer >> ffiDestroy [
	^ self ffiCall: #( void SDL_DestroyRenderer ( self ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiDrawColorR: r g: g b: b a: a [
	^ self ffiCall: #( int SDL_SetRenderDrawColor ( self , Uint8 r , Uint8 g , Uint8 b , Uint8 a ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiDrawLineX1: x1 y1: y1 x2: x2 y2: y2 [
	^ self ffiCall: #( int SDL_RenderDrawLine ( self , int x1 , int y1 , int x2 , int y2 ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiDrawPointX: x y: y [
	^ self ffiCall: #( int SDL_RenderDrawPoint ( self , int x , int y ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiDrawRect: rect [
	^ self ffiCall: #( int SDL_RenderDrawRect ( self , SDL_Rect* rect ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiFillRect: rect [
	^ self ffiCall: #( int SDL_RenderFillRect ( self , SDL_Rect* rect ) )
]

{ #category : #private }
SDL_Renderer >> ffiGetRendererInfo: info [
	^ self ffiCall: #( int SDL_GetRendererInfo (self, SDL_RendererInfo* info) )
]

{ #category : #rendering }
SDL_Renderer >> ffiNoClipRect [
	^ self ffiCall: #( int SDL_RenderSetClipRect ( self , nil ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiNoRenderTarget [
	^ self ffiCall: #( int SDL_SetRenderTarget ( self , nil ) )
]

{ #category : #rendering }
SDL_Renderer >> ffiPresent [
	^ self ffiCall: #( void SDL_RenderPresent ( self ) )
]

{ #category : #rendering }
SDL_Renderer >> fillRect: rect [

	^ SDL2Library defer: [ self ffiFillRect: rect ]

]

{ #category : #accessing }
SDL_Renderer >> info [
	| info |
	
	info := SDL_RendererInfo externalNew autoRelease.
	SDL2Library defer: [ self ffiGetRendererInfo: info ].
	
	^ info
]

{ #category : #initialization }
SDL_Renderer >> initialize [
	self autoRelease
]

{ #category : #rendering }
SDL_Renderer >> noClipRect [

	^ SDL2Library defer: [ self ffiNoClipRect ]
]

{ #category : #rendering }
SDL_Renderer >> noRenderTarget [

	^ SDL2Library defer: [ self ffiNoRenderTarget ]

]

{ #category : #rendering }
SDL_Renderer >> present [

	^ SDL2Library defer: [ self ffiPresent ]

]
