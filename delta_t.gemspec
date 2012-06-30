# -*- encoding: utf-8 -*-
require File.expand_path('../lib/delta_t/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tim 'S.D.Eagle' Zeitz"]
  gem.email         = ["tim.zeitz@googlemail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "delta_t"
  gem.require_paths = ["lib"]
  gem.version       = DeltaT::VERSION
end
