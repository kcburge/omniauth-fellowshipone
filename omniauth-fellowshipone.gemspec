$:.push File.expand_path("../lib", __FILE__)
require "omniauth-fellowshipone/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-fellowshipone"
  s.version     = FellowshipOne::Version::STRING
  s.summary     = %q{OmniAuth strategy for Fellowship One"}
  s.email       = "kcburge@gmail.com"
  s.homepage    = "http://github.com/kcburge/omniauth-fellowshipone"
  s.description = %q{OmniAuth strategy for Fellowship One"}
  s.authors     = ['Kevin Burge']

  s.rubyforge_project = "omniauth-fellowshipone"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'omniauth-oauth', '~> 1.0'
  s.add_runtime_dependency 'multi_json', '~> 1.0'
end
