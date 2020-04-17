"
I represent a handle of SDL2 window, coming from SDL2 library
"
Class {
	#name : #'SDL_Window',
	#superclass : #SDL2Handle,
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #finalization }
SDL_Window class >> destroyWindow: handle [
	self ffiCall: #( void SDL_DestroyWindow ( void *handle ) ) 
]

{ #category : #finalization }
SDL_Window class >> finalizeResourceData: aTuple [
	| handle windowId |
	
	handle := aTuple first.
	handle isNull ifTrue: [ ^ self ].

	windowId := aTuple second.
	OSSDL2Driver current unregisterWindowWithId: windowId.	
	self destroyWindow: handle.
	handle beNull
]

{ #category : #rendering }
SDL_Window >> createDefaultRenderer [
	^ self createRenderer: -1 flags: 0
]

{ #category : #rendering }
SDL_Window >> createRenderer: driverIndex flags: flags [

	^ (SDL2Library defer: [ self ffiCreateRenderer: driverIndex flags: flags ]) initialize

]

{ #category : #initialize }
SDL_Window >> destroy [
	OSSDL2Driver current unregisterWindowWithId: self windowID.
	SDL2Library defer: [ self ffiDestroy ].
	handle beNull
]

{ #category : #private }
SDL_Window >> ffiCreateRenderer: driverIndex flags: flags [
	^ self ffiCall: #( SDL_Renderer SDL_CreateRenderer ( self , int driverIndex , Uint32 flags ) )
]

{ #category : #private }
SDL_Window >> ffiDestroy [
	^ self ffiCall: #( void SDL_DestroyWindow ( self ) )
]

{ #category : #accessing }
SDL_Window >> ffiFullscreen: flags [
	^ self ffiCall: #( int SDL_SetWindowFullscreen ( self , Uint32 flags ) )
]

{ #category : #surface }
SDL_Window >> ffiGetFlags [
	^ self ffiCall: #( Uint32 SDL_GetWindowFlags ( self ) )
]

{ #category : #accessing }
SDL_Window >> ffiGetPositionX: x y: y [
	^ self ffiCall: #( void SDL_GetWindowPosition ( self , int* x , int* y ) )
]

{ #category : #accessing }
SDL_Window >> ffiGetSizeW: w h: h [
	^ self ffiCall: #( void SDL_GetWindowSize ( self , int* w , int* h ) )
]

{ #category : #'window management' }
SDL_Window >> ffiGetWMInfo: infos [
	^ self ffiCall: #( bool SDL_GetWindowWMInfo( self, SDL_SysWMinfo* infos) )
]

{ #category : #surface }
SDL_Window >> ffiGetWindowSurface [
	^ self ffiCall: #( SDL_Surface* SDL_GetWindowSurface( self ) )
]

{ #category : #'window management' }
SDL_Window >> ffiHide [
	^ self ffiCall: #( void SDL_HideWindow( self ) )
]

{ #category : #accessing }
SDL_Window >> ffiIcon: surface [
	^ self ffiCall: #( void SDL_SetWindowIcon ( self , SDL_Surface* surface ) )
]

{ #category : #'text input' }
SDL_Window >> ffiIsTextInputActive [
	^ self ffiCall: #(bool SDL_IsTextInputActive(void))
]

{ #category : #'window management' }
SDL_Window >> ffiMaximize [
	^ self ffiCall: #( void SDL_MaximizeWindow( self ) )
]

{ #category : #'window management' }
SDL_Window >> ffiMinimize [
	^ self ffiCall: #( void SDL_MinimizeWindow( self ) )
]

{ #category : #'window management' }
SDL_Window >> ffiRaise [

	^ self ffiCall: #( void SDL_RaiseWindow( self ) )
]

{ #category : #'window management' }
SDL_Window >> ffiRestore [
	^ self ffiCall: #( void SDL_RestoreWindow( self ) )
]

{ #category : #'window management' }
SDL_Window >> ffiSetHitTest: callback [
	^ self ffiCall: #( int SDL_SetWindowHitTest( self , DraggableCallback callback, nil ) )
]

{ #category : #accessing }
SDL_Window >> ffiSetPositionX: x y: y [
	^ self ffiCall: #( void SDL_SetWindowPosition ( self , int x , int y ) )
]

{ #category : #accessing }
SDL_Window >> ffiSetSizeW: w h: h [
	^ self ffiCall: #( void SDL_SetWindowSize ( self , int w , int h ) )
]

{ #category : #'window management' }
SDL_Window >> ffiShow [
	^ self ffiCall: #( void SDL_ShowWindow( self ) )
]

{ #category : #'text input' }
SDL_Window >> ffiStartTextInput [
	^ self ffiCall: #(void SDL_StartTextInput(void))
]

{ #category : #'text input' }
SDL_Window >> ffiStopTextInput [
	^ self ffiCall: #(void SDL_StopTextInput(void))
]

{ #category : #accessing }
SDL_Window >> ffiTitle [
	^ self ffiCall: #( String SDL_GetWindowTitle ( self ) )
]

{ #category : #accessing }
SDL_Window >> ffiTitle: title [
	^ self ffiCall: #( void SDL_SetWindowTitle ( self , String title ) )
]

{ #category : #'window management' }
SDL_Window >> ffiToggleBorder: bordered [
	^ self ffiCall: #( void SDL_SetWindowBordered( self, bool bordered ) )
]

{ #category : #surface }
SDL_Window >> ffiUpdateWindowSurface [
	^ self ffiCall: #( int SDL_UpdateWindowSurface( self ) )
]

{ #category : #surface }
SDL_Window >> ffiUpdateWindowSurfaceRects: rects num: numrects [
	^ self ffiCall: #( int SDL_UpdateWindowSurfaceRects( self , void* rects , int numrects) )
]

{ #category : #accessing }
SDL_Window >> ffiWindowID [
	^ self ffiCall: #( Uint32 SDL_GetWindowID ( self ) )
]

{ #category : #accessing }
SDL_Window >> fullscreen: flags [

	^ SDL2Library defer: [ self ffiFullscreen: flags ]

]

{ #category : #surface }
SDL_Window >> getFlags [

	^ SDL2Library defer: [ self ffiGetFlags ]

]

{ #category : #accessing }
SDL_Window >> getPositionX: x y: y [
	
	^ SDL2Library defer: [ self ffiGetPositionX: x y: y ]

]

{ #category : #accessing }
SDL_Window >> getSizeW: w h: h [

	^ SDL2Library defer: [ self ffiGetSizeW: w h: h ]

]

{ #category : #'window management' }
SDL_Window >> getWMInfo: infos [

	^ SDL2Library defer: [ self ffiGetWMInfo: infos ]

]

{ #category : #surface }
SDL_Window >> getWindowSurface [

	^ SDL2Library defer: [ self ffiGetWindowSurface ]

]

{ #category : #'window management' }
SDL_Window >> hide [

	^ SDL2Library defer: [ self ffiHide ]

]

{ #category : #accessing }
SDL_Window >> icon: surface [

	^ SDL2Library defer: [ self ffiIcon: surface ]

]

{ #category : #'text input' }
SDL_Window >> isTextInputActive [

	^ SDL2Library defer: [ self ffiIsTextInputActive ]

]

{ #category : #'window management' }
SDL_Window >> maximize [

	^ SDL2Library defer: [ self ffiMaximize ]

]

{ #category : #'window management' }
SDL_Window >> minimize [

	^ SDL2Library defer: [ self ffiMinimize ]

]

{ #category : #'window management' }
SDL_Window >> raise [

	^ SDL2Library defer: [ self ffiRaise ].
]

{ #category : #'external resource management' }
SDL_Window >> resourceData [
	^ {self getHandle. self windowID }
]

{ #category : #'window management' }
SDL_Window >> restore [
	
	^ SDL2Library defer: [ self ffiRestore ].
]

{ #category : #'window management' }
SDL_Window >> setHitTest: callback [

	^ SDL2Library defer: [ self ffiSetHitTest: callback ].
]

{ #category : #accessing }
SDL_Window >> setPositionX: x y: y [

	^ SDL2Library defer: [ self ffiSetPositionX: x y: y ].
]

{ #category : #accessing }
SDL_Window >> setSizeW: w h: h [

	^ SDL2Library defer: [ self ffiSetSizeW: w h: h ].
]

{ #category : #'window management' }
SDL_Window >> show [

	^ SDL2Library defer: [ self ffiShow ].
]

{ #category : #'text input' }
SDL_Window >> startTextInput [

	^ SDL2Library defer: [ self ffiStartTextInput ].
]

{ #category : #'text input' }
SDL_Window >> stopTextInput [

	^ SDL2Library defer: [ self ffiStopTextInput ].
]

{ #category : #accessing }
SDL_Window >> title [

	^ SDL2Library defer: [ self ffiTitle ].
]

{ #category : #accessing }
SDL_Window >> title: title [

	^ SDL2Library defer: [ self ffiTitle: title ].
]

{ #category : #'window management' }
SDL_Window >> toggleBorder: bordered [
	
	^ SDL2Library defer: [ self ffiToggleBorder: bordered ].
]

{ #category : #surface }
SDL_Window >> updateWindowSurface [

	^ SDL2Library defer: [ self ffiUpdateWindowSurface  ].
]

{ #category : #surface }
SDL_Window >> updateWindowSurfaceRects: rects num: numrects [

	^ SDL2Library defer: [ self ffiUpdateWindowSurfaceRects: rects num: numrects ].

]

{ #category : #accessing }
SDL_Window >> windowID [

	^ SDL2Library defer: [ self ffiWindowID ].
]
