# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_extend/version'

Gem::Specification.new do |gem|
  gem.name          = "hash_extend"
  gem.version       = HashExtend::VERSION
  gem.authors       = ["Thomas Petrachi"]
  gem.email         = ["thomas.petrachi@vodeclic.com"]
  gem.description   = %q{in dev : extend hash methods}
  gem.summary       = %q{in dev : add :delete_many}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
