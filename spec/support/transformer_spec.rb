describe "Maglev::Support::Transformer" do
  describe ".to" do
    it "should produce an NSValueTransformer" do
      t = Maglev::Support::Transformer.to(NSString) do |value|
        value + " test"
      end
      t.is_a?(NSValueTransformer).should == true

      _t = t.alloc.init
      _t.transformedValue("hello").should == "hello test"
    end

    it "should not be reversable by default" do
      t = Maglev::Support::Transformer.to(NSString) do |value|
        value + " test"
      end
      t.allowsReverseTransformation.should == false
    end

    it "should allow reversing" do
      t = Maglev::Support::Transformer.to(NSString) do |value, reverse_value|
        if reverse_value
          reverse_value[0..-6]
        else
          value + " test"
        end
      end
      t.allowsReverseTransformation.should == true

      _t = t.alloc.init
      _t.transformedValue("hello").should == "hello test"
      _t.reverseTransformedValue("hello test").should == "hello"
    end
  end
end