# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'middleman-org/version'

Gem::Specification.new do |s|
  s.name        = 'middleman-org'
  s.version     = Middleman::Org::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Xiaoxing Hu']
  s.email       = ['dawnstar.hu@gmail.com']
  s.homepage    = 'http://github.com/xiaoxinghu/middleman-org'
  s.summary     = %q{org-mode extension for middleman}
  s.description = %q{Middleman extension for publishing org-mode project}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.license = 'MIT'
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency('middleman-core', ['~> 3.3'])

  # Additional dependencies
  s.add_runtime_dependency('org-ruby', '~> 0.9.12')
  s.add_runtime_dependency('addressable', '~> 2.3')
  s.add_runtime_dependency('nokogiri', '~> 1.6')
  s.add_runtime_dependency('emacs-ruby', '~> 0.1')
end
