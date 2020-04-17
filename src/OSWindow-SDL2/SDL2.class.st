"
A bunch of functions in a single class for accessing SDL2 interface
"
Class {
	#name : #SDL2,
	#superclass : #Object,
	#classVars : [
		'Session'
	],
	#pools : [
		'SDL2Constants',
		'SDL2ConstantsHint'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #'error handling' }
SDL2 class >> checkForError [

	SDL2Library defer: [:sdlLibrary | sdlLibrary checkForError ]
]

{ #category : #clipboard }
SDL2 class >> clipboardText [
	| text |
	
	text := SDL2Library defer: [:aSDLLibrary | aSDLLibrary clipboardText].	
	^ text isNull ifTrue: [''] ifFalse: [text readStringUTF8].

]

{ #category : #clipboard }
SDL2 class >> clipboardText: text [
	| encoded encoder |
	
	encoded := ByteArray streamContents: [ :stream |
		encoder := ZnUTF8Encoder new.
		encoder 
			next: text size 
			putAll: text asString
			startingAt: 1 
			toStream: stream.
		stream nextPut: 0 ].
	
	encoded pinInMemory.
	
	SDL2Library defer: [ :aSDLLibrary | aSDLLibrary clipboardText: encoded ]

]

{ #category : #cursor }
SDL2 class >> createCursor: data mask: mask w: w h: h hotX: hotX hotY: hotY [

	^ SDL2Library defer: [ :aSDL2Library | 
		aSDL2Library createCursor: data mask: mask w: w h: h hotX: hotX hotY: hotY ]
]

{ #category : #cairo }
SDL2 class >> createRGBSurfaceForCairoWidth: width height: height [

	^ (SDL2Library
		defer: [ :aSDLLibrary | aSDLLibrary createRGBSurfaceForCairoWidth: width height: height ])
		initialize
]

{ #category : #video }
SDL2 class >> createRGBSurfaceFromPixels: pixels width: width height: height depth: depth pitch: pitch rmask: rmask gmask: gmask bmask: bmask amask: amask [

	^ SDL2Library
		defer: [ :aSDL2Library | 
			aSDL2Library
				createRGBSurfaceFromPixels: pixels
				width: width
				height: height
				depth: depth
				pitch: pitch
				rmask: rmask
				gmask: gmask
				bmask: bmask
				amask: amask ]
]

{ #category : #video }
SDL2 class >> createWindow: title x: x y: y width: w height: h flags: flags [
	^ SDL2Library
		defer: [ :aSDL2Library | 
			aSDL2Library createWindow: title x: x y: y width: w height: h flags: flags ]
]

{ #category : #timer }
SDL2 class >> delay: milliseconds [

	^ SDL2Library defer:[ :aSDL2Library | aSDL2Library delay: milliseconds ].

]

{ #category : #video }
SDL2 class >> disableScreenSaver [

	^ SDL2Library
		defer: [ :aSDL2Library | 
			aSDL2Library disableScreenSaver ]
]

{ #category : #video }
SDL2 class >> freeSurface: surface [

	^ SDL2Library
		defer: [ :aSDL2Library | aSDL2Library freeSurface: surface ]
]

{ #category : #'game controller' }
SDL2 class >> gameControllerNameForIndex: deviceIndex [
 
	^ SDL2Library defer: [ :aSDL2Library | 
		aSDL2Library gameControllerNameForIndex: deviceIndex ]
]

{ #category : #'game controller' }
SDL2 class >> gameControllerOpen: deviceIndex [
 
	^ SDL2Library defer: [ :aSDL2Library | 
		aSDL2Library gameControllerOpen: deviceIndex ]
]

{ #category : #opengl }
SDL2 class >> glCreateContext: window [

	^ SDL2Library defer:[ :aSDL2Library | aSDL2Library glCreateContext: window ].

]

{ #category : #opengl }
SDL2 class >> glGetAttribute: attr [
	| value result |
   value := ExternalAddress allocate: 4.

	SDL2Library defer:[ :aSDL2Library | aSDL2Library glGetAttribute: attr into: value ].

	result := value unsignedLongAt: 1.
	value free.
	^result
]

{ #category : #opengl }
SDL2 class >> glGetProcAddress: procName [

	^ SDL2Library defer:[ :aSDL2Library | aSDL2Library glGetProcAddress: procName ].

]

{ #category : #opengl }
SDL2 class >> glMakeCurrent: window context: context [

	^ SDL2Library defer:[ :aSDL2Library | aSDL2Library glMakeCurrent: window context: context ].

]

{ #category : #opengl }
SDL2 class >> glSetAttribute: attr value: value [

	^ SDL2Library defer:[ :aSDL2Library | aSDL2Library glSetAttribute: attr value: value ].

]

{ #category : #opengl }
SDL2 class >> glSwapWindow: window [

	^ SDL2Library defer:[ :aSDL2Library | aSDL2Library glSwapWindow: window ].

]

{ #category : #common }
SDL2 class >> initEverything [
	self initLibrary.
	SDL2Library defer: [:aSDL2Library | aSDL2Library initSubSystem: SDL_INIT_EVERYTHING]
]

{ #category : #common }
SDL2 class >> initGameController [
	self initLibrary.
	SDL2Library defer: [:aSDL2Library | aSDL2Library initSubSystem: SDL_INIT_GAMECONTROLLER]	

]

{ #category : #common }
SDL2 class >> initJoystick [
	self initLibrary.
	SDL2Library defer: [:aSDL2Library | aSDL2Library initSubSystem: SDL_INIT_JOYSTICK]	
		
	
]

{ #category : #common }
SDL2 class >> initLibrary [
	Session == Smalltalk session ifTrue: [ ^ 1 ].
	"Configure SDL2 in 'application mode', to let the screen to turn off on inactivity.
	 But we let the user to restore 'game mode' on screen, by using #disableScreenSaver"
	
	self initPlatformSpecific.
	
	self setHint: SDL_HINT_VIDEO_ALLOW_SCREENSAVER value: '1'.
	self setHint: SDL_HINT_NO_SIGNAL_HANDLERS value: '1'.
	SDL2Library defer:[ :aSDL2Library | aSDL2Library init: SDL_INIT_NOPARACHUTE ].
	Session := Smalltalk session.
]

{ #category : #common }
SDL2 class >> initPlatformSpecific [

	Smalltalk os isMacOSX ifTrue: [  
		SDLOSXPlatformInitializer new run.	
	] 
]

{ #category : #common }
SDL2 class >> initVideo [
	self initLibrary.
	SDL2Library defer: [:aSDL2Library | aSDL2Library initSubSystem: SDL_INIT_VIDEO]	
		
]

{ #category : #common }
SDL2 class >> isAvailable [

	SDL2Library uniqueInstance isAvailable

]

{ #category : #'game controller' }
SDL2 class >> isGameController: deviceIndex [
 
	^ SDL2Library defer: [ :aSDL2Library | 
		aSDL2Library isGameController: deviceIndex ]
]

{ #category : #joystick }
SDL2 class >> joystickEventState: state [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library joystickEventState: state ]
]

{ #category : #joystick }
SDL2 class >> joystickOpen: deviceIndex [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library joystickOpen: deviceIndex ]
]

{ #category : #mouse }
SDL2 class >> modState [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library modState ]
]

{ #category : #mouse }
SDL2 class >> mouseState [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library mouseState ]
]

{ #category : #mouse }
SDL2 class >> mouseStateX: x y: y [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library mouseStateX: x y: y ]
]

{ #category : #joystick }
SDL2 class >> numberOfJoysticks [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library numberOfJoysticks ]
]

{ #category : #event }
SDL2 class >> pollEvent: event [
 
	^ SDL2Library defer: [ :aSDL2Library | 
		aSDL2Library pollEvent: event ]
]

{ #category : #common }
SDL2 class >> quit [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library quit ]
]

{ #category : #common }
SDL2 class >> quitSubSystem: flags [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library quitSubSystem: flags ]
]

{ #category : #video }
SDL2 class >> setHint: aName value: aValue [

	^ SDL2Library
		defer: [ :aSDL2Library | aSDL2Library setHint: aName value: aValue ]
]

{ #category : #mouse }
SDL2 class >> setRelativeMouseMode: enabled [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library setRelativeMouseMode: enabled ]
]

{ #category : #cursor }
SDL2 class >> showCursor: toggle [

	^ SDL2Library defer: [ :aSDL2Library | 
		aSDL2Library showCursor: toggle ]
]

{ #category : #timer }
SDL2 class >> ticks [

	^ SDL2Library defer:[ :aSDL2Library | aSDL2Library ticks ].

]

{ #category : #common }
SDL2 class >> wasInit: flags [

	^ SDL2Library defer: [ :aSDL2Library | aSDL2Library wasInit: flags]
]
