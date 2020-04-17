"
I represent  handle of a mouse cursor.
"
Class {
	#name : #'SDL_Cursor',
	#superclass : #SDL2Handle,
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #'freeing resources' }
SDL_Cursor >> ffiFreeCursor [
	^ self ffiCall: #( void SDL_FreeCursor ( self ) )
]

{ #category : #'using the cursor' }
SDL_Cursor >> ffiSetCursor [
	^ self ffiCall: #( void SDL_SetCursor ( self ) )
]

{ #category : #'freeing resources' }
SDL_Cursor >> freeCursor [
	^ SDL2Library defer: [ self ffiFreeCursor ]
]

{ #category : #'using the cursor' }
SDL_Cursor >> setCursor [

	^ SDL2Library defer: [ self ffiSetCursor ]
]
