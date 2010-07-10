Class {
	#name : #PageRankerExample,
	#superclass : #Object,
	#category : #'PageRank-Core'
}

{ #category : #examples }
PageRankerExample >> importantClassesIn: aBrowserEnvironment [
	"self new importantClassesIn: (BrowserEnvironment new)"
	"self new importantClassesIn: (BrowserEnvironment new forPackageNames: #('TextLint-Model'))"
	
	| graph ranks result |
	graph := IdentityDictionary new.
	aBrowserEnvironment classesAndSelectorsDo: [ :class :selector |
		| collection |
		collection := graph 
			at: class theNonMetaClass name
			ifAbsentPut: [ 
				class superclass isNil 
					ifTrue: [ IdentitySet new ] 
					ifFalse: [ IdentitySet with: class superclass name ]].
		(class compiledMethodAt: selector) literalsDo: [ :each |
			(each isVariableBinding and: [ each key isSymbol ])
				ifTrue: [ collection add: each key ] ] ].
	ranks := PageRanker new 
		outlinks: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: graph keys.
	result := (graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ])
		collect: [ :each | each -> (ranks at: each) ].
	^ result first: 25
]

{ #category : #examples }
PageRankerExample >> importantSelectorsIn: aBrowserEnvironment [
	"self new importantSelectorsIn: (BrowserEnvironment new)"
	"self new importantSelectorsIn: (BrowserEnvironment new forPackageNames: #('TextLint-Model'))"
	
	| graph ranks result primitives |
	graph := IdentityDictionary new.
	aBrowserEnvironment classesAndSelectorsDo: [ :class :selector |
		| collection method |
		collection := graph
			at: selector 
			ifAbsentPut: [ OrderedCollection new ].
		method := class compiledMethodAt: selector.
		method primitive = 0 ifTrue: [ 
			method messagesDo: [ :each |
				each isSymbol
					ifTrue: [ collection add: each ] ] ] ].
	(graph keys count: #size) inspect.
	ranks := PageRanker new 
		outlinks: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: graph keys.
	result := (graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ])
		collect: [ :each | each -> (ranks at: each) ].
	^ result first: 25
]
