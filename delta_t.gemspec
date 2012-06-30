# -*- encoding: utf-8 -*-
require File.expand_path('../lib/delta_t/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tim 'S.D.Eagle' Zeitz"]
  gem.email         = ["dev.tim.zeitz@gmail.com"]
  gem.description   = %q{Making time difference calculations fun}
  gem.summary       = %q{Provides a class to represent time differences and make calculations nice and easy}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "delta_t"
  gem.require_paths = ["lib"]
  gem.version       = DeltaT::VERSION

  gem.add_development_dependency 'rake'

  gem.add_runtime_dependency 'activesupport'
end
