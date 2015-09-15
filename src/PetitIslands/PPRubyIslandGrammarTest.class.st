Class {
	#name : #PPRubyIslandGrammarTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitIslands-Examples'
}

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> parserClass [
	^ PPRubyIslandGrammar
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testClass [
	self parse: 
'class Foo 
end' rule: #classDef.
	
	self assert: result size = 0.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testClass2 [
	self parse: '
	class Foo 
		def bar
		end
	end'.
	self assert: result size = 1.
	self assert: result first = '::Foo.bar'.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testClass3 [
	self parse: '
	class Foo 
		def bar
		end
		
		def baz
		end
	end'.
	self assert: result size = 2.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo.baz'.	
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testClass4 [
	self parse: '
	class Foo 
		def bar
		end
		
		some mess
		
		def baz
		end
	end'.
	self assert: result size = 2.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo.baz'.	
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testClass5 [
	self parse: '
	class Foo 
		def bar()
			new("with a very
				/* and comment */ cool string over multiple lines")
		end
		
		def baz
			yet "another" string
		end
		
		def bag
		end
	end'.
	self assert: result size = 3.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo.baz'.	
	self assert: result third = '::Foo.bag'
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testClass6 [
	"
	The known case when the Island Indent Parser fails
	"
"
	self parse: '
module Plugins
	class Foo 
		class Bar < Barr; end
		def baz()
			if something
				return true if whatever
			end
		end
	end
end'.
	self assert: result size = 1.
	self assert: result first = '::Plugins::Foo.baz'.
"
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testDanglingEnd1 [
	self parse: '
	class Foo 
		def bar
		end
		
		a if b
		
		def baz
		end
	end'.

	self assert: result size = 2.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo.baz'.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testDanglingEnd2 [
	self parse: '
	class Foo 
		def bar
		end
		
		if a then  b else c end
		
		def self.baz
		end
	end'.

	self assert: result size = 2.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo.self.baz'.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testEigenClass1 [
	self parse: '
	class Foo 
		def bar()
		end
		
		class << self
			def baz
				yet "another" string
			end
		
			def bag
			end
		end
	end'.
	self assert: result size = 3.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo.self.baz'.	
	self assert: result third = '::Foo.self.bag'
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testLine [
	self parse: 'aaa' rule: #line.
	self parse: '  aaa' rule: #line.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethod1 [
	self parse: 'def bar end' 
	rule: #methodDef.

	self assert: result size = 1.
	self assert: result first = '.bar'.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethod2 [
	self parse: 'def self.bar 
		1+1
	end' rule: #methodDef.

	self assert: result size = 1.
	self assert: result first = '.self.bar'.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethod3 [
	self parse: 'def suspend_record
    					UserHistory.for(a).order(''id DESC'').first
  					 end' rule: #methodDef.

	self assert: result size = 1.
	self assert: result first = '.suspend_record'.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethod4 [
	self parse: 'def bar 
end' rule: #methodDef.
	
	self assert: result size = 1.
	self assert: result first = '.bar'.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethod5 [
	self parse: 'def bar=(val)
end' rule: #methodDef.
	
	self assert: result size = 1.
	self assert: result first = '.bar='.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethod6 [
	self parse: 'def self.bar end' rule: #methodDef.
	
	self assert: result size = 1.
	self assert: result first = '.self.bar'.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethod7 [
	self parse: 'def self.[] end' rule: #methodDef.
	
	self assert: result size = 1.
	self assert: result first = '.self.[]'.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testMethodWithMethod1 [
	self parse: 'def bar
		def baz
		end
end' rule: #methodDef.
	
	self assert: result size = 2.
	self assert: result first = '.bar.baz'.
	self assert: result second = '.bar'.

]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testModule [
	self parse: '
	module Foo 
		def bar
		end
	end'.
	self assert: result size = 1.
	self assert: result first = '::Foo.bar'.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testNestedClass1 [
	self parse: '
	class Foo 
		def bar
		end
		
		class Baz
			def bazz
			end
		end
		
		def bazz
		end
		
	end'.
	self assert: result size = 3.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo::Baz.bazz'.
	self assert: result third = '::Foo.bazz'.	
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testOnsideLine [
	self parse: 'aaa' rule: #onsideLine.
	self fail: '  aaa' rule: #onsideLine.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testProgram [
	self parse: 'class Foo end'.
	self assert: result size = 0.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testProgram2 [
	self parse: '
	class Foo 
		def bar
		end
		
		def self.baz
		end
	end'.
	self assert: result size = 2.
	self assert: result first = '::Foo.bar'.
	self assert: result second = '::Foo.self.baz'.	
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testProgram3 [
	self parse: '
	class Foo 
		title = 123
		if () end
	
		def bar
		end
	end'.
	self assert: result size = 1.
	self assert: result first = '::Foo.bar'.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testProgram4 [
	self parse: '
	require_dependency ''post_creator''	
	
	class Foo 
		title = 123
		if () end
	
		def bar
		end
	end'.
	self assert: result size = 1.
	self assert: result first = '::Foo.bar'.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testProgram5 [
	self parse: '
	class Foo 
		def bar
		end
	end
	
	def baz
	end
	'.

	self assert: result first = '::Foo.bar'.
	self assert: result second = '.baz'.
]

{ #category : #'as yet unclassified' }
PPRubyIslandGrammarTest >> testProgram6 [
	self parse: '
class Bar
   def foo	
    [case duration
      when a
        created_at
      when b
        previous_visit_at
      else
        duration.minutes.ago
      end, user_stat.new_since].max
   end
end'.
	self assert: result first = '::Bar.foo'.

]
