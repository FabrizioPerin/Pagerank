Class {
	#name : #PageRankerExample,
	#superclass : #Object,
	#category : #'PageRank-Tests'
}

{ #category : #examples }
PageRankerExample >> importantClassesIn: aBrowserEnvironment [
	"self new importantClassesIn: (BrowserEnvironment new)"
	"self new importantClassesIn: (BrowserEnvironment new forPackageNames: #('TextLint-Model'))"
	
	| graph ranks result |
	graph := IdentityDictionary new.
	aBrowserEnvironment classesAndSelectorsDo: [ :class :selector |
		| collection |
		class isTrait ifFalse: [ 
			collection := graph 
				at: class theNonMetaClass name
				ifAbsentPut: [ 
					class superclass isNil 
						ifTrue: [ IdentitySet new ] 
						ifFalse: [ IdentitySet with: class superclass name ] ].
			((class compiledMethodAt: selector) literals allButLast: 2) do: [ :each |
				(each isVariableBinding and: [ each key isSymbol ])
					ifTrue: [ collection add: each key ] ] ] ].
	ranks := PageRanker new
		stepper: [ :each | Transcript show: '.' ];
		outlinks: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: graph keys.
	result := (graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ])
		collect: [ :each | each -> (ranks at: each) ].
	^ result
]

{ #category : #examples }
PageRankerExample >> importantObjects [
	"self new importantObjects"
	
	| objects |
	Smalltalk garbageCollect.
	objects := OrderedCollection new.
	self systemNavigation allObjectsDo: [ :each |
		(objects == each or: [ objects collector == each ])
			ifFalse: [ objects addLast: each ] ].
	^ self importantObjectsIn: objects asArray
]

{ #category : #examples }
PageRankerExample >> importantObjectsIn: anArray [
	"(self new importantObjects first: 100) inspect"
	
	| graph ranks result |
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
	ranks := PageRanker new
		stepper: [ :count | Transcript show: count; cr ];
		outlinks: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: anArray.
	^ anArray sort: [ :a :b | (ranks at: a) >= (ranks at: b) ]
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
	ranks := PageRanker new 
		stepper: [ :each | Transcript show: '.' ];
		outlinks: [ :each | graph at: each ifAbsent: [ #() ] ];
		runOn: graph keys.
	result := (graph keys 
		asSortedCollection: [ :a :b | (ranks at: a) >= (ranks at: b) ])
		collect: [ :each | each -> (ranks at: each) ].
	^ result
]
