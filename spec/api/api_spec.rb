describe "Maglev::API" do
  it "uses a DSL for setup" do
    Maglev::API.setup do
      root "root"
      extension "json"
      default_url_options do
        token 3
      end
    end

    Maglev::API.root.should == "root"
    Maglev::API.extension.should == "json"
    Maglev::API.default_url_options.should == { "token" => 3 }
  end
end