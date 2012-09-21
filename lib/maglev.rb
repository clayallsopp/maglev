require "maglev/version"
require 'bubble-wrap/core'
require 'bubble-wrap/http'
require 'motion_support/all'
require 'formotion'

BW.require File.expand_path('../maglev/**/*.rb', __FILE__) do

  ["http", "options"].each do |f|
    file("lib/maglev/api.rb").depends_on file("lib/maglev/api/#{f}.rb")
  end

  ["attributes", "hashable", "relationships", "urls", "record"].each do |f|
    file("lib/maglev/model/#{f}.rb").depends_on file("lib/maglev/support.rb")
    file("lib/maglev/model.rb").depends_on file("lib/maglev/model/#{f}.rb")
  end

  file("lib/maglev/model.rb").depends_on file("lib/maglev/api.rb")
end
