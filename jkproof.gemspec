# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jkproof/version'

Gem::Specification.new do |spec|
  spec.name          = 'jkproof'
  spec.version       = Jkproof::VERSION
  spec.authors       = ['tosite']
  spec.email         = ['tl091264@gmail.com']
  spec.summary       = 'This performs sentence proofreading using a dictionary.yml.'
  spec.description   = 'This performs sentence proofreading using a dictionary.yml.'
  spec.homepage      = 'https://github.com/tosite0345/jkproof'

  # spec.summary       = %q{TODO: Write a short summary, because RubyGems requires one.}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    # spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata['homepage_uri']    = 'https://github.com/tosite0345/jkproof'
    spec.metadata['source_code_uri'] = 'https://github.com/tosite0345/jkproof'
    spec.metadata['changelog_uri']   = 'https://github.com/tosite0345/jkproof'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'highline'
  spec.add_dependency 'xml-simple'
end
