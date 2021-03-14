Class {
	#name : #SoInliningLog,
	#superclass : #SoDebugLog,
	#category : #'ScorchingDev-debug'
}

{ #category : #printing }
SoInliningLog >> basicPrintOn: stream [
	stream << message
]
