class Movie < Maglev::Model
  collection_path "/me/movies", json_path: "data"

  remote_attributes :name, :id
end