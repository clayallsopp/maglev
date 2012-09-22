class Movie < Maglev::Model
  collection_path "/me/movies", json_path: "data"
  member_path "/:id"

  remote_attributes :name, :id
  remote_attribute :cover_url, json_path: "cover.source"
end