Class {
	#name : #PageRankTest,
	#superclass : #TestCase,
	#instVars : [
		'graph',
		'ranks',
		'ranker'
	],
	#category : #'PageRank-Tests'
}

{ #category : #running }
PageRankTest >> setUp [
	super setUp.
	graph := Dictionary new.
	graph at: #a put: #(c).
	graph at: #b put: #(a).
	graph at: #c put: #(a).
	graph at: #d put: #(c b).
	ranker := PageRank new.
	ranker referenced: [ :node | graph at: node ]
]

{ #category : #tests }
PageRankTest >> testFirstStep [
	ranker iterations: 1; damping: 1.
	ranks := ranker runOn: graph keys.
	self assert: ((ranks at: #a) closeTo: 0.5).
	self assert: ((ranks at: #b) closeTo: 0.125).
	self assert: ((ranks at: #c) closeTo: 0.375).
	self assert: ((ranks at: #d) closeTo: 0.0).
]

{ #category : #tests }
PageRankTest >> testInitialStep [
	ranker iterations: 0; damping: 1.
	ranks := ranker runOn: graph keys.
	self assert: ((ranks at: #a) closeTo: 0.25).
	self assert: ((ranks at: #b) closeTo: 0.25).
	self assert: ((ranks at: #c) closeTo: 0.25).
	self assert: ((ranks at: #d) closeTo: 0.25).
]

{ #category : #tests }
PageRankTest >> testSecondStep [
	ranker iterations: 2; damping: 1.
	ranks := ranker runOn: graph keys.
	self assert: ((ranks at: #a) closeTo: 0.5).
	self assert: ((ranks at: #b) closeTo: 0.0).
	self assert: ((ranks at: #c) closeTo: 0.5).
	self assert: ((ranks at: #d) closeTo: 0.0).
]

{ #category : #tests }
PageRankTest >> testSelfReference [
	| result |
	result := ranker
		referenced: [ :node | #(a) ];
		runOn: #(a).
	self assert: (result size) = 1.
	self assert: (result at: #a) > 0
]

{ #category : #tests }
PageRankTest >> testSingleNode [
	| result |
	result := ranker
		referenced: [ :node | #() ];
		runOn: #(a).
	self assert: (result size) = 1.
	self assert: ((result at: #a) closeTo: 0.15)
]

{ #category : #tests }
PageRankTest >> testStepping [
	| stepping |
	stepping := OrderedCollection new.
	ranker
		iterations: 5; 
		step: [ :value | stepping addLast: value ];
		runOn: graph keys.
	self assert: stepping size = 5.
	self assert: stepping first = 1.
	self assert: stepping last = 5
]

{ #category : #tests }
PageRankTest >> testTwoNodeLoop [
	| result |
	result := ranker
		referenced: [ :node | node = #a ifTrue: [ #(b) ] ifFalse: [ #(a) ] ];
		runOn: #(a b).
	self assert: (result size) = 2.
	self assert: ((result at: #a) closeTo: 1.0).
	self assert: ((result at: #b) closeTo: 1.0)
]
