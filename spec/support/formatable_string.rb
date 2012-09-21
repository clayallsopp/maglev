describe "FormatableString" do
  it "works" do
    s = Maglev::Support::FormatableString.new("herp/:derp/my_string/:hello")
    
    s.format(derp: "test", hello: "earth").should == "herp/test/my_string/earth"

    o = Object.new
    def o.derp
      "jelly"
    end

    def o.hello
      "toast"
    end

    s.format({}, o).should == "herp/jelly/my_string/toast"
  end
end