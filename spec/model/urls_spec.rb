class CustomUrlModel < Maglev::Model
  collection_path "collection"
  member_path "collection/:id"

  custom_paths :a_path => "custom", :format_path => "custom/:var",
    :method_path => "custom/:a_method"

  def id
    8
  end

  def a_method
    10
  end
end

describe "URLs" do
  it "should make visible urls at class and instance level" do
    CustomUrlModel.a_path.should == "custom"
    CustomUrlModel.collection_path.should == "collection"
    CustomUrlModel.member_path.should == "collection/:id"

    # NOTE that Class.member_path(params) won't work (it's the setter).
    CustomUrlModel.member_path.format(:id => 9).should == "collection/9"

    c = CustomUrlModel.new
    c.collection_path.should == "collection"
    c.member_path.should == "collection/8"
    c.a_path.should == "custom"

    CustomUrlModel.format_path.should == "custom/:var"
    c.format_path(:var => 3).should == "custom/3"
    c.method_path.should == "custom/10"
  end
end