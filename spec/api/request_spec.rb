describe "Requests" do
  it "should parse json" do
    Maglev::API.get("http://graph.facebook.com/btaylor") do |response, json|
      json.class.should == Hash
      response.ok?.should == true
      @ran = true
      resume
    end
    # really stupid, haven't made an async request example...
    wait_max 5.0 do
      @ran.should == true
    end
  end
end