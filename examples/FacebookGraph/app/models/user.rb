class User < Maglev::Model
  remote_attributes :id, :name, :bio

  has_many :friends,
    class_name: "User",
    collection_path: "/:id/friends",
    member_path: "/:id",
    json_path: "data"

  has_many :movies,
    collection_path: "/:id/movies",
    json_path: "data"

  has_one :wall,
    class_name: "Post",
    member_path: "/posts"

  collection_path ""
  member_path "/:id"
end