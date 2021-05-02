"
I represent an object to reconstruct. I can refer to markers OR other deopt nodes.

theClass <Behavior>
marker<SunkObjectMarker> unique id for the object
"
Class {
	#name : #SoAbsDeoptObject,
	#superclass : #SoAbsDeoptNode,
	#instVars : [
		'marker',
		'theClass'
	],
	#category : #'Scorching-Deoptimization'
}

{ #category : #enumerating }
SoAbsDeoptObject >> allFieldsDo: ablock [
	"nothing"
]

{ #category : #deoptimization }
SoAbsDeoptObject >> asObjectTemplate [
	self subclassResponsibility 
]

{ #category : #accessing }
SoAbsDeoptObject >> marker [

	^ marker
]

{ #category : #accessing }
SoAbsDeoptObject >> marker: aValue [
	
	marker := aValue
]

{ #category : #accessing }
SoAbsDeoptObject >> theClass [
	
	^ theClass
]

{ #category : #accessing }
SoAbsDeoptObject >> theClass: aValue [
	<generated>
	theClass := aValue
]
