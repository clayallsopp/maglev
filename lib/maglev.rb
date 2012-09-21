require "maglev/version"
require 'bubble-wrap/core'
require 'remote_model'
require 'formotion'

BW.require File.expand_path('../maglev/**/*.rb', __FILE__) do
  ["attributes", "hashable", "relationships"].each do |f|
    file("lib/maglev/model/#{f}.rb").depends_on file("lib/maglev/support.rb")
    file("lib/maglev/model.rb").depends_on file("lib/maglev/model/#{f}.rb")
  end
end
