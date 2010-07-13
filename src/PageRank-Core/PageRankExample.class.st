Class {
	#name : #PageRankExample,
	#superclass : #Object,
	#category : #'PageRank-Tests'
}

{ #category : #examples }
PageRankExample >> importantClassesIn: aBrowserEnvironment [
	"self new importantClassesIn: (BrowserEnvironment new)"
	"self new importantClassesIn: (BrowserEnvironment new forPackageNames: #('VB-Regex'))"
	
	| graph ranks result |
	graph := IdentityDictionary new.
	aBrowserEnvironment classesAndSelectorsDo: [ :class :selector |
		class isTrait ifFalse: [
			| collection |
			collection := graph 
				at: class theNonMetaClass name
				ifAbsentPut: [
					class theNonMetaClass superclass isNil
						ifTrue: [ OrderedCollection new ]
						ifFalse: [ OrderedCollection with: class theNonMetaClass superclass name ] ].
			((class compiledMethodAt: selector) literals allButLast: 2) do: [ :each |
				(each isVariableBinding and: [ each key isSymbol ])
					ifTrue: [ collection add: each key ] ] ] ].
	ranks := PageRank new
		referenced: [ :each | graph at: each ];
		runOn: graph keys.
	result := (graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ])
		collect: [ :each | each -> (ranks at: each) ].
	^ result
]

{ #category : #examples }
PageRankExample >> importantObjects [
	"self new importantObjects"
	
	| objects |
	Smalltalk garbageCollect.
	objects := OrderedCollection withAll: (-1024 to: 1024).
	self systemNavigation allObjectsDo: [ :each |
		(objects == each or: [ objects collector == each ])
			ifFalse: [ objects addLast: each ] ].
	^ self importantObjectsIn: objects asArray
]

{ #category : #examples }
PageRankExample >> importantObjectsIn: anArray [
	"self new importantObjects inspect"
	
	| graph ranks |
	graph := IdentityDictionary new: anArray size.
	anArray do: [ :each |
		| children |
		children := OrderedCollection new.
		each class isVariable ifTrue: [
			1 to: each basicSize do: [ :index |
				children add: (each basicAt: index) ] ].
		1 to: each class instSize do: [ :index |
			children add: (each instVarAt: index) ].
		graph at: each put: children asArray ].
	ranks := PageRank new
		nodes: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: anArray.
	^ anArray sort: [ :a :b | (ranks at: a) >= (ranks at: b) ]
]

{ #category : #examples }
PageRankExample >> importantSelectorsIn: aBrowserEnvironment [
	"self new importantSelectorsIn: (BrowserEnvironment new)"
	"self new importantSelectorsIn: (BrowserEnvironment new forPackageNames: #('VB-Regex'))"
	
	| graph ranks result |
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
	ranks := PageRank new 
		referenced: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: graph keys.
	result := (graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ])
		collect: [ :each | each -> (ranks at: each) ].
	^ result
]
