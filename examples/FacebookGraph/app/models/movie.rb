class Movie < Maglev::Model
  collection_path ""
  member_path "/:id"

  remote_attributes :name, :id
  remote_attribute :cover_url, json_path: "cover.source"
end