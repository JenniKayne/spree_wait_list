lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree_wait_list/version'

Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.name          = 'spree_wait_list'
  spec.version       = SpreeWaitList::VERSION
  spec.authors       = ['Wojtek']
  spec.email         = ['wojtek@praesens.co']

  spec.summary       = 'Add a waiting list to your spree store'
  spec.description   = 'The waiting list allows users to signup to be notified via email when an items comes back into stock'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spree_version = '~> 3.3.0'
  spec.add_dependency 'spree_core', spree_version
end
