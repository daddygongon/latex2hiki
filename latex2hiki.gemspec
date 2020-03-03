# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'latex2hiki/version'

Gem::Specification.new do |spec|
  spec.name          = "latex2hiki"
  spec.version       = Latex2hiki::VERSION
  spec.authors       = ["Shigeto R. Nishitani"]
  spec.email         = ["shigeto_nishitani@me.com"]

  spec.summary       = %q{latex to hiki format converter.}
  spec.description   = %q{latex2hiki is a format convert from latex to hikidoc.}
  spec.homepage      = 'https://github.com/daddygongon/latex2hiki'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
#  if spec.respond_to?(:metadata)
#    spec.metadata['allowed_push_host'] = 'http://nishitani0.kwansei.ac.jp/~bob/nishitani0/gems/'
#  else
#    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
#  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "hiki2md"
  spec.add_development_dependency "mathjax-yard"
end
