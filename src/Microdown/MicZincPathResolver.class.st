"
I am a path resolver for Microdown.
References in Microdown (links, images and input files) can either be absolute references to a specific file or http address, or relative to an absolute reference.

I am a visitor which is given a `MicAbsoluteResourceReference`, and traverses a document and **resolves** all relative references with respect to the base reference. The resolution is to replace the relative reference with an absolute one.

The mention of `Zinc` in my name is a credit to  `ZnUrl`, which does the underlying resolution according to [rfc3986 Uniform Resource Identifier (URI): Generic Syntax/Reference Resolution](https://datatracker.ietf.org/doc/html/rfc3986#section-5).

In particular, [rfc3986](https://datatracker.ietf.org/doc/html/rfc3986) is independent of file or http-based URIs. It is the same algorithm used by all web browsers for image and link resolution of relative references.

## Key Method & Implementation
I am used by calling my class side method `resolve:withBase:`. 

If the base is a file-based reference with an explicit filesystem (see comment in `MicFileResourceReference`), I take that into account.

When parsing a resource reference (image, link or input file) that is relative, instances of `MicRelativeResourceReference`s are created in the parse nodes for `MicFigureBlock`, `MicLinkBlock` or `MicInputfileBlock`. I will replace all relative references in these blocks with absolute references based on the rfc3986 algorithm mentioned above.
"
Class {
	#name : 'MicZincPathResolver',
	#superclass : 'MicrodownVisitor',
	#instVars : [
		'absoluteReference'
	],
	#category : 'Microdown-Core',
	#package : 'Microdown',
	#tag : 'Core'
}

{ #category : 'instance creation' }
MicZincPathResolver class >> resolve: document withBase: aRef [
	"Assumes aRef to be a MicAbsoluteRessourceReference. 
	Converts all relative references to absolute references in document"
	self new
		absoluteReference: aRef;
		resolveDocument: document
		
]

{ #category : 'accessing' }
MicZincPathResolver >> absoluteReference: aReferenceOrString [
	absoluteReference := aReferenceOrString isString
		ifTrue: [ MicResourceReference fromUri: aReferenceOrString ]
		ifFalse: [ aReferenceOrString ]
]

{ #category : 'visiting' }
MicZincPathResolver >> resolveDocument: document [
	self visit: document
]

{ #category : 'private' }
MicZincPathResolver >> resolveReferenceIn: aNode [
	"currently links, figures and input nodes need to be resolved"
	| resolvedUri resolvedReference |
	aNode reference isRelative ifFalse: [ ^ self ].
	resolvedUri := absoluteReference uri withRelativeReference: aNode reference relativePath.
	resolvedReference := MicResourceReference fromUri: resolvedUri printString.
	resolvedReference isMicrodownResourceFileReference ifTrue: [ resolvedReference filesystem: absoluteReference filesystem ].
	aNode reference: resolvedReference
]

{ #category : 'visiting' }
MicZincPathResolver >> visitFigure: aFigure [

	self resolveReferenceIn: aFigure
]

{ #category : 'visiting' }
MicZincPathResolver >> visitInputFile: anInputFile [


	self resolveReferenceIn: anInputFile 
]

{ #category : 'visiting' }
MicZincPathResolver >> visitLink: aLink [
	self resolveReferenceIn: aLink
]
