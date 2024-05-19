
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slotty/version"

Gem::Specification.new do |spec|
  spec.name          = "slotty"
  spec.version       = Slotty::VERSION
  spec.authors       = ["Hayden Rouille"]
  spec.email         = ["hayden@rouille.dev"]

  spec.summary       = %q{Generate available slots between time ranges}
  spec.description   = %q{Slotty will determine the available time slots for a given period, taking in a set of pre-existing busy periods and a timeframe of the appointment}
  spec.homepage      = "https://github.com/haydenrou/slotty"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.3.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.5.9"
  spec.add_development_dependency "rake", "~> 13.2.1"
  spec.add_development_dependency "rspec", "~> 3.13"
end
