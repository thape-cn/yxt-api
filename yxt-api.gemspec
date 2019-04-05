# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yxt-api/version'

Gem::Specification.new do |spec|
  spec.name          = 'yxt-api'
  spec.version       = Yxt::VERSION
  spec.authors       = ['Eric Guo']
  spec.email         = ['eric.guocz@gmail.com']

  spec.summary       = 'An unofficial 云学堂 http://www.yxt.com/ API wrap gem'
  spec.description   = 'Helping rubyist integration with YXT API easier.'
  spec.homepage      = 'https://github.com/thape-cn/yxt-api'
  spec.license       = 'MIT'
  spec.required_ruby_version = '~> 2.3'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end - %w(yxt-api.sublime-project Gemfile Rakefile yxt-api.gemspec certs/Eric-Guo.pem)
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.cert_chain  = ['certs/Eric-Guo.pem']
  spec.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $PROGRAM_NAME.end_with?('gem')

  spec.add_runtime_dependency 'http', '>= 2.0.3', '< 5'
  spec.add_development_dependency 'rake', '~> 11.3'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
