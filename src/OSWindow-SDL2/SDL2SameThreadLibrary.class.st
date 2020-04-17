Class {
	#name : #SDL2SameThreadLibrary,
	#superclass : #SDL2Library,
	#instVars : [
		'event',
		'eventType'
	],
	#pools : [
		'SDL2Constants',
		'SDL2ConstantsHint',
		'SDL2Types'
	],
	#category : #'OSWindow-SDL2-Bindings'
}

{ #category : #event }
SDL2SameThreadLibrary >> pushEvent: event [
	^ self ffiCall: #( Uint32 SDL_PushEvent ( SDL_Event event ) )
]

{ #category : #'as yet unclassified' }
SDL2SameThreadLibrary >> pushUserEvent [

	event ifNil: [ ^ self ].

	event type: eventType.
	self pushEvent: event	
]

{ #category : #'as yet unclassified' }
SDL2SameThreadLibrary >> registerEvent [

	eventType := self registerEvent: 1.
	event := SDL_UserEvent new.
	
	
]

{ #category : #'accessing platform' }
SDL2SameThreadLibrary >> runner [

	^ TFSameThreadRunner uniqueInstance
]
