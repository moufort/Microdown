Class {
	#name : 'MicRichTextComposerTest',
	#superclass : 'TestCase',
	#instVars : [
		'sample',
		'parser',
		'composer',
		'offlineStatus'
	],
	#category : 'Microdown-RichTextComposer-Tests-Composer',
	#package : 'Microdown-RichTextComposer-Tests',
	#tag : 'Composer'
}

{ #category : 'as yet unclassified' }
MicRichTextComposerTest class >> sampleMicrodownForInputTest [
	^ '# TestHeader
body for testing'
]

{ #category : 'helpers' }
MicRichTextComposerTest >> assertWriting: aPRDocument include: expectedAttribute [
	self assert: ((self runsOf: aPRDocument) includes: {expectedAttribute})
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> boldFormat [
	^ TextEmphasis bold
]

{ #category : 'helpers' }
MicRichTextComposerTest >> composer [
	
	composer ifNotNil: [ ^ composer ].
	^ composer := self composerClass new
]

{ #category : 'helpers' }
MicRichTextComposerTest >> composerClass [
	^ MicRichTextComposer
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> externalLink: aLink [
	^ TextAction new actOnClickBlock: [WebBrowser openOn: aLink]
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> figure: aFigureLink [
	| url |
	url := aFigureLink.
	^ TextAnchor new anchoredMorph: (ZnEasy getPng: url)
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> headerLevel1 [

	^ self composer textStyler headerLevelFont: 1
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> headerLevel2 [

	^ self composer textStyler headerLevelFont: 2
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> headerLevel3 [

	^ self composer textStyler headerLevelFont: 3
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> headerLevel4 [

	^ self composer textStyler headerLevelFont: 4
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> headerLevel5 [

	^ self composer textStyler headerLevelFont: 5
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> headerLevel6 [

	^ self composer textStyler headerLevelFont: 6
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> italicFormat [
	^ TextEmphasis italic
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> microElementsFrom: aString [
	^ sample documentFrom: aString.
	
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> monospaceFormat [
	^ TextBackgroundColor color: Smalltalk ui theme settings windowColor
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> normalFormat [
	^ TextEmphasis normal
]

{ #category : 'helpers' }
MicRichTextComposerTest >> richTextFor: aDocument [

	^ self composer visit: aDocument
]

{ #category : 'helpers' }
MicRichTextComposerTest >> richTextForString: aString [

	^ self composer asRichText: aString
]

{ #category : 'helpers' }
MicRichTextComposerTest >> runsOf: aDocument [
	
	^ (self richTextFor: aDocument) runs
]

{ #category : 'running' }
MicRichTextComposerTest >> setUp [
	super setUp.
	sample := MicMicrodownSnippetFactory new.
	parser := Microdown new.
	offlineStatus := Microdown offline.
	Microdown offline: false.

]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> strikethroughtFormat [
	^ TextEmphasis struckOut
]

{ #category : 'helpers' }
MicRichTextComposerTest >> stringOf: aPRDocument [
	
	^ (self richTextFor: aPRDocument) string
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> subscriptFormat [
	^ TextColor red
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> superscriptFormat [
	^ TextColor blue
]

{ #category : 'running' }
MicRichTextComposerTest >> tearDown [
	Microdown offline: offlineStatus.
	super tearDown.
]

{ #category : 'tests' }
MicRichTextComposerTest >> testBackslashLast [
	| source richText |
	source := 'I am a text which ends in \'.
	richText := self richTextForString: source.
	self assert: richText asString trim equals: source
]

{ #category : 'tests' }
MicRichTextComposerTest >> testBackslashNoBreak [
	"This test is related to issue: https://github.com/pillar-markup/Microdown/issues/107"
	| source richText |
	source := 'I''m a simple lexer. I''m used bt the DLitlleLParser.

I recogniseI
- names: list of characters letter and number and ''
- separators: one character separator.
- escape char \

Whitespaces and separators can be customised using setters.
Subclasses may change the definition of names by redefining isCurrentALetter.'.
	richText := self richTextForString: source.
	self assert: true "I did not fail"
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> testBoldFormat [

	self assertWriting: (self microElementsFrom: sample boldFormatSample) include: self boldFormat
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> testCenter [
	| src doc|
	src := '
<!center
This is centered
!>'.
	doc := Microdown parse: src.
	self assertWriting: doc include: TextAlignment centered 
]

{ #category : 'tests - codeBlock' }
MicRichTextComposerTest >> testCodeBlock [

	| source runs richText |
	source := '
```arguments
line 1
line 2
```
'.
	richText := self richTextForString: source.
	runs := (richText runs collect: [:run | run collect: [:a| a class]]) asArray .	
		 
	self assert: (runs second includes: TextIndent).
	self assert: richText asString trim equals: 
'line 1
line 2'
]

{ #category : 'tests - codeBlock' }
MicRichTextComposerTest >> testCodeBlockStylerExplicitLanguage [

	| source richText expected |
	source := '
```language=dummyForTest
line 1
line 2
```
'.
	expected := '§dummy§'.
	richText := self richTextForString: source.
	self assert: richText asString trim equals: expected
]

{ #category : 'tests - codeBlock' }
MicRichTextComposerTest >> testCodeBlockStylerShortHand [

	| source richText expected |
	source := '
```dummyForTest
line 1
line 2
```
'.
	expected := '§dummy§'.
	richText := self richTextForString: source.
	self assert: richText asString trim equals: expected
]

{ #category : 'tests - codeBlock' }
MicRichTextComposerTest >> testCodeBlockWithCaption [

	| source runs richText |
	source := '
```caption=Roger Rabbit
line 1
line 2
```
'.
	richText := self richTextForString: source.
	runs := richText runs asArray.	
	
	self assert: runs first notEmpty. 
	self assert: (runs second anySatisfy: [ :r | r class = TextIndent]).
	self assert: ((runs at: 15) includes: self boldFormat ).
	self assert: richText asString trim equals: 
'line 1
line 2
an Array(Text(Roger Rabbit))'
]

{ #category : 'tests - codeBlock' }
MicRichTextComposerTest >> testCodeBlockWithTabbedCode [

	| source richText |
	source := '
```
7
	8
```
'.
	richText := self richTextForString: source.
	self assert: richText asString trim equals: '7
	8'
]

{ #category : 'tests' }
MicRichTextComposerTest >> testEnvironment_unknownShouldNotFail [
	| src |
	src := '
<!card 
stuff
!>
'.
	Microdown asRichText: src
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testExternaLink [

	| source richText obj1 |
	source := 'See [my anchor](https://pharo.org)'.
	richText := self composerClass asRichText: source.

	obj1 := (richText runs at: 10) first. "element 10 is the 'n' in anchor"
	self assert: obj1 class name equals: #TextAction
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testFigureCaptionMissingRemote [

	| source richText|
	source := 'See ![SomeText](https://pharo.org/web/files/pharooooooo.png)'.
	richText := self composerClass asRichText: source.

	self assert: (richText asString trim includesSubstring: 'SomeText').
	self assert: richText asTextMorph height < 100 "No image embedded"
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testFigureCaptionRemote [

	| source richText |
	source := 'See ![SomeText](https://pharo.org/web/files/pharo.png)'.
	richText := self composerClass asRichText: source.

	self deny: (richText asString trim includesSubstring: 'SomeText').
	self assert: richText asTextMorph height > 100 "It is high because of the embedded image"
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testFigureNoCaptionRemote [

	| source richText |
	source := 'See ![](https://pharo.org/web/files/pharo.png)'.
	richText := self composerClass asRichText: source.

	self assert: (richText asString trim first: 6) equals: 'See  ', (String value: 1).
	self assert: richText asTextMorph height > 100 "It is high because of the embedded image"
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> testHeaderLevel1 [

	self 
		assertWriting: (self microElementsFrom: sample headerLevel1Sample) 
		include: self headerLevel1
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> testHeaderLevel2 [

	self 
		assertWriting: (self microElementsFrom: sample headerLevel2Sample) 
		include: self headerLevel2
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> testHeaderLevel3 [

	self 
		assertWriting: (self microElementsFrom: sample headerLevel3Sample) 
		include: self headerLevel3
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> testHeaderLevel4 [

	self 
		assertWriting: (self microElementsFrom: sample headerLevel4Sample) 
		include: self headerLevel4
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> testHeaderLevel5 [

	self 
		assertWriting: (self microElementsFrom: sample headerLevel5Sample) 
		include: self headerLevel5
]

{ #category : 'tests - header' }
MicRichTextComposerTest >> testHeaderLevel6 [

	self 
		assertWriting: (self microElementsFrom: sample headerLevel6Sample) 
		include: self headerLevel6
]

{ #category : 'tests' }
MicRichTextComposerTest >> testInputfile [

	| source result |
	source := '<!inputFile|path=pharo:///MicRichTextComposerTest/sampleMicrodownForInputTest!>'.
	result := (self richTextForString: source) asString trim.
	self assert: (result beginsWith: 'TestHeader').
	self assert: (result includesSubstring: 'body for test')
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testItalicFormat [

	| source runs richText |
	source := 'This have been _emphasized_'.
	richText := self richTextForString: source.
	runs := richText runs asArray.
	
	self assert: runs first isEmpty. 
	self assert: ((runs at: 19 "the p in emphasized") includes: self italicFormat ).
	self deny: ((runs at: 6 "the h in have") includes: self italicFormat  ).
]

{ #category : 'tests - list' }
MicRichTextComposerTest >> testLatexMathStyleEmpty [

	| source richText |
	source :=  'foo$$bar'.
	richText := self richTextForString: source.
	self assert: richText asString trim equals: 'foobar' .
]

{ #category : 'tests - list' }
MicRichTextComposerTest >> testListAreCorrectlyNumbered [

	| source richText |
	source :=
'1. item 1
1. other item 1
2. item 2
3. item 3
4. item 4'.
	richText := self richTextForString: source. 
	self assert: (richText asString copyFrom: 11 to: 25) equals: '2.	other item 1'.
	self assert: (richText asString copyFrom: 47 to: 55) equals: '5.	item 4'.
	
]

{ #category : 'tests' }
MicRichTextComposerTest >> testMathEnvironmentError [
	| source richText |
	source :=  'foo
$$
\include{nowhere.com}
$$
'.
	richText := self richTextForString: source.
	self assert: richText asString equals: 'foo

$$ - LATEX ERROR - $$'
]

{ #category : 'tests' }
MicRichTextComposerTest >> testNestedList [
	"I just need to be here and succeed to override an existing test which is obsolete"
	| silly |
	silly := 'absolutely'.
	self assert: silly equals: silly
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testNestedMixedList [

	| source richText runs |
	source := 
'- item 1
  1. sub item 1.1
- item 2
  2. sub item 2.1
  2. sub item 2.2
- item 3'.
	richText := self richTextForString: source.
	runs := richText runs.
	
	"check that 'sub item 2.1' is numbered 'A)' and is rightly indented"
	self assert: (richText asString copyFrom: 35 to: 36) equals: 'A)'.
	self assert: (runs at: 36) first amount equals: 3
	
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testNestedMixedListNoEmptyLinesAfterSubLists [

	| source output |
	source := 
'- item 1
  1. sub item 1.1
- item 2
  2. sub item 2.1
     - sub item 2.1.1
- item 3'.
	output := (self richTextForString: source) asString trim.
	self assert: output lines size equals: 6
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testNestedUnorderdList [

	| source richText |
	source := 
'- item 1
  - sub item 1.1
- item 2
  - sub item 2.1
  - sub item 2.2
- item 3'.
	richText := self richTextForString: source.
	"check that 'sub item 1.1' is bulleted and is rightly indented"
	self assert: (richText asString includesSubstring: '•	item 2').
	self assert: (richText asString includesSubstring: '-	sub item 2.1')
	
]

{ #category : 'tests - list' }
MicRichTextComposerTest >> testNewDictionaryAPI [
	
	| dict |
	dict := Dictionary newFrom: { #a -> 1  . #b -> 2 }.
	self assert: (dict at: #a) equals: 1
]

{ #category : 'tests - list' }
MicRichTextComposerTest >> testNoNSuperfluousNewLines [

	| source richText expected |
	source :=  'This is **bold**

And this is just an other paragraph'.
	expected := 'This is bold

And this is just an other paragraph'.
	richText := self richTextForString: source.
	self assert: richText asString equals: expected
]

{ #category : 'tests - list' }
MicRichTextComposerTest >> testNoSuperfluousNewLines [

	| source richText expected |
	source :=  'This is **bold**'.
	expected := 'This is bold'.
	richText := self richTextForString: source.
	self assert: richText asString equals: expected
]

{ #category : 'tests - list' }
MicRichTextComposerTest >> testOrderedList [

	| source richText runs  |
	source := '1. First item
2. Second item
   on two lines
3. Third item'.
	richText := self richTextForString: source.
	runs := richText runs .
	
	self assert: runs first first class equals: TextIndent.
	self assert: runs first first amount equals: 1.
	self assert: (runs at: 30) "the first o in 'on two lines'" first class equals: TextIndent.
	self assert: (runs at: 30) first amount equals: 2.
	
]

{ #category : 'tests' }
MicRichTextComposerTest >> testOrderedNestedList [
	| source richText   |
	source := '
1. First item
   2. Second item
      3. Third item'.
	richText := self richTextForString: source.
	self assert: (richText asString includesSubstring: '1.	First item').
	self assert: (richText asString includesSubstring: 'A)	Second item').
	self assert: (richText asString includesSubstring: 'a)	Third item')
	
]

{ #category : 'tests' }
MicRichTextComposerTest >> testOrderedNestedListNoEmptyLinesAfterSubLists [
	| source output |
	source := '
1. First item
   2. Second item
      3. Third item
4. Fourth item'.
	output := (self richTextForString: source) asString trim.
	self assert: output lines size equals: 4.
]

{ #category : 'tests - paragraph' }
MicRichTextComposerTest >> testParagraphNotFormat [

	| runs richText |
	richText := self richTextFor: (self microElementsFrom: '
foo
barwith a space').
	runs := richText runs.
	self assert: (runs allSatisfy: [ :format | format = #() ] )

]

{ #category : 'tests' }
MicRichTextComposerTest >> testQuoteBlock [
	| src richText |
	"Quote blocks have not been implemented"
	src := '> foo'.
	richText := Microdown asRichText: src.
	"should at least include foo somehow"
	self deny: (richText asString findString: 'foo') equals: 0
]

{ #category : 'tests' }
MicRichTextComposerTest >> testRaw [
	| text |
	text := Microdown asRichText: '{{**not bold**}}'.
	self assert: text asString trim equals: '**not bold**'.
]

{ #category : 'tests' }
MicRichTextComposerTest >> testRawNewLinesPreserved [
	| text |
	text := Microdown asRichText: '{{**not 
bold**}}'.
	self assert: text asString trim equals: '**not
bold**'.
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> testRightAlignment [ 
	| src doc|
	src := '
<!right
This is righted
!>'.
	doc := Microdown parse: src.
	self assertWriting: doc include: TextAlignment rightFlush  
]

{ #category : 'skipped tests' }
MicRichTextComposerTest >> testStrikethroughFormat [ 
	| source runs richText |
	source := 'This have been ~deleted~'.
	richText := self richTextForString: source.
	runs := richText runs asArray.
	
	self assert: runs first isEmpty. 
	self assert: ((runs at: 19 "the l in deleted") includes: self strikethroughtFormat ).
	self deny: ((runs at: 6 "the h in have") includes: self strikethroughtFormat ).
]

{ #category : 'tests' }
MicRichTextComposerTest >> testStylerForMethod [
	
	| code source richText blueLocation textColor |
	code := '
codeStylerFor: aString
<codeblockStylerFor: #smalltalk>

^bobby new 
isForWorkspace: blue; 
styledTextFor: aString asFest'.
	source := '
```language=method' , code ,'
```
'.
	richText := self richTextForString: source.
	
	self assert: richText asString trim equals: code trim.
	self assert: ((richText attributesAt: 2) includes: TextEmphasis bold).
	"Check that the unknown variable 'blue' is not colored red"
	blueLocation := richText asString findString: 'blue'.
	textColor := (richText attributesAt: blueLocation) detect: [ :attr | attr class = TextColor  ].
	self assert: textColor color red equals: 0.
]

{ #category : 'tests - list' }
MicRichTextComposerTest >> testUnorderedList [

	| source richText runs  |
	source :=  '- First item
- Second item
   on two lines
- Third item'.
	richText := self richTextForString: source.
	runs := richText runs.
	self assert: runs first first class equals: TextIndent.
	self assert: runs first first amount equals: 1.
	self assert: (runs at: 29) "the first o in 'on two lines'" first class equals: TextIndent.
	self assert: (runs at: 29) first amount equals: 2.
]

{ #category : 'tests' }
MicRichTextComposerTest >> testUnorderedNestedListNoEmptyLinesAfterSubLists [
	| source output |
	source := '
- First item
  - Second item
    - Third item
- Fourth item'.
	output := (self richTextForString: source) asString trim.
	self assert: output lines size equals: 4.
]

{ #category : 'tests - format' }
MicRichTextComposerTest >> underlineFormat [
	^ TextEmphasis underlined
]
