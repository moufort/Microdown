"
I am a block containing a Pharo expression.

A script showing my visitors:
```language=text
 ```pharoeval
 Transcript show: 'Test'; cr.
 ```
```
Gives:
```pharoeval
Transcript show: 'Test'; cr.
```
 
"
Class {
	#name : 'MicPharoEvaluatorBlock',
	#superclass : 'MicScriptBlock',
	#category : 'Microdown-Extensions',
	#package : 'Microdown',
	#tag : 'Extensions'
}

{ #category : 'accessing' }
MicPharoEvaluatorBlock class >> tag [

	^ #pharoeval
]

{ #category : 'visiting' }
MicPharoEvaluatorBlock >> accept: aVisitor [
	^ aVisitor visitPharoEvaluator: self
]

{ #category : 'accessing' }
MicPharoEvaluatorBlock >> label [

	^ arguments at: #label ifAbsent: [ nil ]
]

{ #category : 'accessing' }
MicPharoEvaluatorBlock >> title [
	^ arguments at: 'title' ifAbsent: [ '' ]
]
