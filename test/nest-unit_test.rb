require File.join(File.dirname(__FILE__), *%w[test_helper])

class ContextTest < Test::Unit::TestCase
  attr_reader :callable
  
  include RR::Adapters::TestUnit
  
  def setup
    @callable = Object.new
    stub(callable).after! { true }
    stub(callable).call!
    stub(callable).called? { false }
  end
  
  helper :helped? do
    true
  end
  
  test "has test helper" do
    assert true
  end
  
  test "doesn't have before" do
    assert !callable.called?
  end
  
  test "has helper helper" do
    assert helped?
  end
  
  context "with a helper method" do
    helper :overrideable do
      :outside
    end
    
    helper :do_something do
      :ok
    end
    
    helper :returner do |arg|
      arg
    end
    
    test "can access top level helper methods" do
      assert helped?
    end
    
    test "can access helper methods" do
      assert_equal :ok, do_something
    end
    
    test "can take a block" do
      assert_equal :ok, returner(:ok)
    end
    
    context "with an inner helper method" do
      helper :overrideable do
        :inside
      end
      
      helper :do_something_else do
        :also_ok
      end
      
      test "can access helper methods" do
        assert_equal :also_ok, do_something_else
      end
      
      test "can override helpers" do
        assert_equal :inside, overrideable
      end
      
      test "can access outer helper methods" do
        assert_equal [:ok, :also_ok], [do_something, do_something_else]
      end
    end
  end

  context "within a context block" do
    before do
      stub(callable).called? { true }
    end
    
    test "has before" do
      assert callable.called?
    end
    
    test "has after" do
      mock(callable).call!
    end
    
    after do
      callable.call!
    end
  end
  
  test "isn't called outside of context" do
    assert !callable.called?
  end
  
  context "with nested contexts" do
    before do
      @call_count = 1
    end
    
    test "should perform original before" do
      assert_equal 1, @call_count
    end
    
    test "should before original after" do
      mock(callable).after!
    end
    
    context "within nested context" do
      before do
        @call_count += 2
      end
      
      test "should perform both original before and nested" do
        assert_equal 3, @call_count
      end
      
      test "should perform both original after and nested" do
        mock(callable).after!.twice
      end
      
      after do
        callable.after!
      end
    end
    
    context "when not using `test` helper" do
      before do
        @before_called = callable.before!
      end
      
      def test_calls_before_block
        assert @before_called, "before not called"
      end
    end
    
    after do
      callable.after!
    end
  end
end