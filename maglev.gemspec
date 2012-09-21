# -*- encoding: utf-8 -*-
require File.expand_path('../lib/maglev/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "maglev"
  s.version     = Maglev::VERSION
  s.authors     = ["Clay Allsopp"]
  s.email       = ["clay.allsopp@gmail.com"]
  s.homepage    = "https://github.com/clayallsopp/maglev"
  s.summary     = "Fast, frictionless iOS development"
  s.description = "Fast, frictionless iOS development"

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "bubble-wrap"
  s.add_dependency "motion_support"
  s.add_development_dependency 'rake'
end