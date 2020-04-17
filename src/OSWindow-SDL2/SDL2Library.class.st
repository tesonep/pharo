Class {
	#name : #SDL2Library,
	#superclass : #FFILibrary,
	#instVars : [
		'inDefer'
	],
	#pools : [
		'SDL2Constants',
		'SDL2ConstantsHint',
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #'deferred message' }
SDL2Library class >> defer: aBlock [
	
	SDL2SameThreadLibrary uniqueInstance pushUserEvent.	
	^ self uniqueInstance defer: aBlock
]

{ #category : #converting }
SDL2Library >> calloutAPIClass [

	^ TFCalloutAPI 
]

{ #category : #'error handling' }
SDL2Library >> checkForError [

	| msg |
	msg := self getErrorMessage.
	msg ~= ''
		ifTrue: [ SDL2Error signal: msg ]
]

{ #category : #clipboard }
SDL2Library >> clipboardText [ 

	^ self ffiCall: #( void* SDL_GetClipboardText ( ) )
]

{ #category : #clipboard }
SDL2Library >> clipboardText: text [
	"It receives a ByteArray because it can be encoded"

	^ self ffiCall: #( int SDL_SetClipboardText ( ByteArray text ) )
]

{ #category : #cursor }
SDL2Library >> createCursor: data mask: mask w: w h: h hotX: hotX hotY: hotY [
	^ self ffiCall: #( SDL_Cursor SDL_CreateCursor ( Uint8* data, Uint8* mask, int w, int h, int hotX, int hotY ) )
]

{ #category : #cairo }
SDL2Library >> createRGBSurfaceForCairoWidth: width height: height [

	^ self ffiCall: #( SDL_Surface* SDL_CreateRGBSurface( 0 , int width , int height , 32 ,
						  16r00FF0000 , 16r0000FF00 , 16r000000FF , 0 ) )
]

{ #category : #video }
SDL2Library >> createRGBSurfaceFromPixels: pixels width: width height: height depth: depth pitch: pitch
	rmask: rmask gmask: gmask bmask: bmask amask: amask [
	^ self ffiCall: #( SDL_Surface* SDL_CreateRGBSurfaceFrom 
						( void* pixels , int width , int height , int depth , int pitch ,
						  Uint32 rmask , Uint32 gmask , Uint32 bmask , Uint32 amask ) )
]

{ #category : #video }
SDL2Library >> createWindow: title x: x y: y width: w height: h flags: flags [
	^ self ffiCall: #( SDL_Window SDL_CreateWindow ( String title, int x, int y, int w, int h, Uint32 flags ) )
]

{ #category : #'deferred message' }
SDL2Library >> defer: aValuable [

	inDefer
		tryEnterCritical: [ ^ aValuable cull: self ]
		ifLocked: [ 
			SDL2SameThreadLibrary uniqueInstance pushUserEvent.
			inDefer critical: [ ^ aValuable cull: self ] ]
]

{ #category : #timer }
SDL2Library >> delay: milliseconds [
	^ self ffiCall: #( void SDL_Delay ( Uint32 milliseconds ) )
]

{ #category : #video }
SDL2Library >> disableScreenSaver [

	^ self ffiCall: #(void SDL_DisableScreenSaver(void))
]

{ #category : #event }
SDL2Library >> doWaitEvent: event [
	^ self ffiCall: #( int SDL_WaitEvent ( SDL_Event event ) )
]

{ #category : #video }
SDL2Library >> freeSurface: surface [
	^ self ffiCall: #( void SDL_FreeSurface ( SDL_Surface* surface ) )
]

{ #category : #'game controller' }
SDL2Library >> gameControllerNameForIndex: deviceIndex [
	^ self ffiCall: #( SDL_String SDL_GameControllerNameForIndex ( int deviceIndex ) )
]

{ #category : #'game controller' }
SDL2Library >> gameControllerOpen: deviceIndex [
	^ self ffiCall: #( SDL_GameController SDL_GameControllerOpen ( int deviceIndex ) )
]

{ #category : #'error handling' }
SDL2Library >> getErrorMessage [

	^ self ffiCall: #( String SDL_GetError ( void ) )
]

{ #category : #opengl }
SDL2Library >> glCreateContext: window [
	^ self ffiCall: #( SDL_GLContext SDL_GL_CreateContext ( SDL_Window window ) )
]

{ #category : #opengl }
SDL2Library >> glGetAttribute: attr into: value [
	^ self ffiCall: #( int SDL_GL_GetAttribute(SDL_GLattr attr, int *value) )
]

{ #category : #opengl }
SDL2Library >> glGetProcAddress: procName [
	^ self ffiCall: #( void* SDL_GL_GetProcAddress ( String procName ) )
]

{ #category : #opengl }
SDL2Library >> glMakeCurrent: window context: context [
	^ self ffiCall: #( int SDL_GL_MakeCurrent ( SDL_Window window , SDL_GLContext context ) )
]

{ #category : #opengl }
SDL2Library >> glSetAttribute: attr value: value [
	^ self ffiCall: #( int SDL_GL_SetAttribute(SDL_GLattr attr, int value) )
]

{ #category : #opengl }
SDL2Library >> glSwapWindow: window [
	^ self ffiCall: #( void SDL_GL_SwapWindow ( SDL_Window window ) )
]

{ #category : #common }
SDL2Library >> init: flags [

	^ self ffiCall: #( int SDL_Init ( Uint32 flags ) )
]

{ #category : #common }
SDL2Library >> initSubSystem: flags [
	^ self ffiCall: #( int SDL_InitSubSystem ( Uint32 flags ) )
]

{ #category : #initialization }
SDL2Library >> initialize [
	
	super initialize.
	inDefer := Mutex new.
]

{ #category : #common }
SDL2Library >> isAvailable [

	^ [ (ExternalAddress loadSymbol: 'SDL_Init' from: self libraryName) notNil ] 
		ifErrorDo: [ false ]
]

{ #category : #'game controller' }
SDL2Library >> isGameController: deviceIndex [
	^ self ffiCall: #( bool SDL_IsGameController ( int deviceIndex ) )
]

{ #category : #joystick }
SDL2Library >> joystickEventState: state [
	^ self ffiCall: #( SDL_Joystick SDL_JoystickEventState ( int state ) )
]

{ #category : #joystick }
SDL2Library >> joystickOpen: deviceIndex [
	^ self ffiCall: #( SDL_Joystick SDL_JoystickOpen ( int deviceIndex ) )
]

{ #category : #'accessing platform' }
SDL2Library >> macLibraryName [

	^ 	'libSDL2-2.0.0.dylib'
]

{ #category : #mouse }
SDL2Library >> modState [
	^ self ffiCall: #( SDL_Keymod SDL_GetModState ( ) )
]

{ #category : #mouse }
SDL2Library >> mouseState [
	^ self ffiCall: #( Uint32 SDL_GetMouseState ( nil , nil ) )
]

{ #category : #mouse }
SDL2Library >> mouseStateX: x y: y [
	^ self ffiCall: #( Uint32 SDL_GetMouseState ( int* x , int* y ) )
]

{ #category : #joystick }
SDL2Library >> numberOfJoysticks [
	^ self ffiCall: #( int SDL_NumJoysticks() )
]

{ #category : #event }
SDL2Library >> pollEvent: event [
	^ self ffiCall: #( int SDL_PollEvent ( SDL_Event event ) )
]

{ #category : #common }
SDL2Library >> quit [
	^ self ffiCall: #( void SDL_Quit ( ) )
]

{ #category : #common }
SDL2Library >> quitSubSystem: flags [
	^ self ffiCall: #( void SDL_QuitSubSystem ( Uint32 flags ) )
]

{ #category : #event }
SDL2Library >> registerEvent: numberOfEvents [
	^ self ffiCall: #( Uint32 SDL_RegisterEvents ( int numberOfEvents ) )
]

{ #category : #'deferred message' }
SDL2Library >> runDeferred [
	| aValuable |

"	[ (aValuable := waitingEvents nextOrNil) isNotNil ]
		whileTrue: [ aValuable value ]"
]

{ #category : #'accessing platform' }
SDL2Library >> runner [

	^ Smalltalk vm isAIOInterrupt 
		ifTrue: [ TFMainThreadRunner uniqueInstance ]
		ifFalse: [ TFSameThreadRunner uniqueInstance ]
]

{ #category : #video }
SDL2Library >> setHint: aName value: aValue [
	^ self ffiCall: #(int SDL_SetHint(const char* aName, const char* aValue))
]

{ #category : #mouse }
SDL2Library >> setRelativeMouseMode: enabled [
	^ self ffiCall: #( int SDL_SetRelativeMouseMode ( bool enabled ) )
]

{ #category : #cursor }
SDL2Library >> showCursor: toggle [
	^ self ffiCall: #( int SDL_ShowCursor ( int toggle ) )
]

{ #category : #timer }
SDL2Library >> ticks [
	"Gets the number of milliseconds since the SDL library was initialized"
	^ self ffiCall: #( Uint32 SDL_GetTicks ( ) )
]

{ #category : #'accessing platform' }
SDL2Library >> unix32LibraryName [ 

	^ 'libSDL2-2.0.so.0'

]

{ #category : #'accessing platform' }
SDL2Library >> unix64LibraryName [ 

	^ 'libSDL2-2.0.so.0'

]

{ #category : #event }
SDL2Library >> waitEvent: anEvent [

	^ inDefer critical: [ self doWaitEvent: anEvent ] 

]

{ #category : #common }
SDL2Library >> wasInit: flags [
	^ self ffiCall: #( int SDL_WasInit ( Uint32 flags ) )
]

{ #category : #'accessing platform' }
SDL2Library >> win32LibraryName [

	^ 'SDL2.dll'	
]
