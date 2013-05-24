require "maglev/version"
require 'bubble-wrap/core'
require 'bubble-wrap/http'
require 'motion_support/all'
require "motion-require"

Motion::Require.all(Dir.glob(File.expand_path('../maglev/**/*.rb', __FILE__)))

Motion::Project::App.setup do |app|
  app.detect_dependencies = false
end