require 'test/unit'

class Test::Unit::TestCase
  def self.test(name, &block)
    define_method("test_" + name.gsub(/[^\w]/, '_'), &block)
  end unless respond_to?(:test)
  
  def self.helper(name, &block)
    define_method(name, &block)
  end unless respond_to?(:helper)
  
  class Context
    attr_reader :parent_context
    
    def initialize(test_case, name, parent_context=nil)
      @test_case, @name, @parent_context = test_case, name, parent_context
    end
    
    def helper(name, &block)
      define_method(name, &block)
    end
    
    def before(&block)
      block_given? ? (@before = block) : @before
    end
    
    def after(&block)
      block_given? ? (@after = block) : @after
    end
    
    def context(name=nil, &block)
      Context.new(@test_case, name, self).instance_eval(&block)
    end
    
    def run_callback(position, kase)
      parent_context.run_callback(position, kase) if has_parent?
      
      if callback = send(position)
        kase.instance_eval(&callback) 
      end
    end
    
    def name
      [parent_name, @name].compact.join('_')
    end
    
    def test(test_name, &block)
      context = self
      @test_case.test [name, test_name].compact.join('_') do
        context.run_callback(:before, self)
        instance_eval(&block)
        context.run_callback(:after, self)
      end
    end
    
    def method_missing(sym, *args,  &block)
      @test_case.send(sym, *args, &block)
    end
    
    private
    
    def parent_name
      has_parent? ? parent_context.name : nil
    end
    
    def has_parent?
      parent_context
    end
  end
  
  def self.context(name=nil, &block)
    Context.new(self, name).instance_eval(&block)
  end
end