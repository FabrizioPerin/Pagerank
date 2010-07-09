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
					ifTrue: [ OrderedCollection new ] 
					ifFalse: [ OrderedCollection with: class superclass name ]].
		(class compiledMethodAt: selector) literalsDo: [ :each |
			(each isVariableBinding and: [ graph includesKey: each key ])
				ifTrue: [ collection addLast: each key ] ] ].
	ranks := PageRanker new 
		outlinks: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: graph keys.
	result := graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ].
	^ result first: 25
]

{ #category : #examples }
PageRankerExample >> importantSelectorsIn: aBrowserEnvironment [
	"self new importantSelectorsIn: (BrowserEnvironment new)"
	"self new importantSelectorsIn: (BrowserEnvironment new forPackageNames: #('TextLint-Model'))"
	
	| graph ranks result |
	graph := IdentityDictionary new.
	aBrowserEnvironment classesAndSelectorsDo: [ :class :selector |
		| collection |
		collection := graph at: selector ifAbsentPut: [ OrderedCollection new ].
		(class compiledMethodAt: selector) messagesDo: [ :each |
			each isSymbol
				ifTrue: [ collection addLast: each ] ] ].
	ranks := PageRanker new 
		outlinks: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: graph keys.
	result := graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ].
	^ result first: 25
]
