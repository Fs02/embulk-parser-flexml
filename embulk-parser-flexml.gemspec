lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "embulk-parser-flexml"
  spec.version       = "0.0.0"
  spec.authors       = ["Surya Asriadie"]
  spec.email         = ["surya.asriadie@gmail.com"]
  spec.summary       = %q{Flexible Embulk parser plugin for XML}
  spec.description   = %q{XML parser plugin is Embulk plugin to fetch entries in xml format. Supports xpath and attributes}
  spec.homepage      = "https://github.com/Fs02/embulk-parser-flexml"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rexml", "~> 3.1"
  spec.add_development_dependency "bundler", "~> 1.0"
  spec.add_development_dependency 'embulk', ['>= 0.9.15']
  spec.add_development_dependency "rake", "~> 10.0"
end