# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_extend/version'

Gem::Specification.new do |gem|
  gem.name          = "hash_extend"
  gem.version       = HashExtend::VERSION
  gem.authors       = ["Thomas Petrachi"]
  gem.email         = ["thomas.petrachi@vodeclic.com"]
  gem.description   = %q{Extend ruby Hash. No override.}
  gem.summary       = %q{Adding methods %w{stealth_delete map_values map_keys delete_many insert compact select_by}}
  gem.homepage      = "https://github.com/petrachi/hash_extend"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
