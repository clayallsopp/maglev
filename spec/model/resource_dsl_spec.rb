class Friend < Maglev::Model
  collection_path "/friends"
  member_path "/friends/:id"
end

class User < Maglev::Model
  has_one :friend
  has_many :friends
  has_many :dsl_friends, class_name: "Friend", collection_path: "/my_friends", member_path: "/my_friends/:id"
end

describe "Nested resource DSL" do
  it "should work" do
    true.should == true
    u = User.new

    u.friend.collection_path.should == '/friends'
    u.friend.member_path.format(id: 5).should == '/friends/5'

    u.friends.collection_path.should == '/friends'
    u.friends.member_path.format(id: 5).should == '/friends/5'

    u.dsl_friends.collection_path.should == '/my_friends'
    u.dsl_friends.member_path.format(id: 5).should == '/my_friends/5'

    ["remote_find", "remote_find_all"].each do |_method|
      u.friends.respond_to?(_method).should == true
      u.dsl_friends.respond_to?(_method).should == true
    end
  end
end