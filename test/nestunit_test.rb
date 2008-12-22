require File.join(File.dirname(__FILE__), *%w[test_helper])

class ContextTest < Test::Unit::TestCase
  attr_reader :callable
  
  include RR::Adapters::TestUnit
  
  def setup
    @callable = Object.new
    stub(callable).before! { true }
    stub(callable).after! { true }
    stub(callable).call!
    stub(callable).called? { false }
  end

  test "has test helper" do
    assert true
  end
  
  test "doesn't have before" do
    assert !callable.called?
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
      mock(callable).call!
    end
    
    context "within nested context" do
      before do
        @call_count += 2
      end
      
      test "should perform both original before and nested" do
        assert_equal 3, @call_count
      end
      
      test "should perform both original after and nested" do
        mock(callable).call!.twice
      end
      
      after do
        callable.call!
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
      callable.call!
    end
  end
end