lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "marea/version"

Gem::Specification.new do |spec|
  spec.name          = "marea"
  spec.version       = Marea::VERSION
  spec.authors       = ["Damián Silvani"]
  spec.email         = ["munshkr@gmail.com"]

  spec.summary       = %q{Musical pattern language for livecoding}
  spec.description   = %q{A musical pattern language inspired in Tidal for
                          building higher-level musical constructs easily.}
  spec.homepage      = "https://github.com/munshkr/marea"
  spec.license       = "GPL-3.0-or-later"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"

  spec.add_runtime_dependency "pry"
end
