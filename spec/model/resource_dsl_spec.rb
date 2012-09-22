class Friend < Maglev::Model
  collection_path "/friends"
  member_path "/friends/:id"
end

class User < Maglev::Model
  has_many :friends
  has_many :dsl_friends, class_name: "Friend", collection_path: "/my_friends", member_path: "/my_friends/:id"
end

describe "Nested resource DSL" do
  it "should work" do
    true.should == true
    u = User.new

    u.friends.collection_path.should == '/friends'
    u.friends.member_path.format(id: 5).should == '/friends/5'

    u.dsl_friends.collection_path.should == '/my_friends'
    u.dsl_friends.member_path.format(id: 5).should == '/my_friends/5'

    #u.friends.find(10) do |friends|
    #end

    #u.dsl_friends.find(10) do |friends|
    #end
  end
end