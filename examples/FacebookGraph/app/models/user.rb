class User < Maglev::Model
  remote_attributes :id, :name, :bio

  collection_path ""
  member_path "/:id"
end