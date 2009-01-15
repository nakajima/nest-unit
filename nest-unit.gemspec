# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nest-unit}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Nakajima"]
  s.date = %q{2009-01-15}
  s.email = %q{patnakajima@gmail.com}
  s.files = ["README.textile", "lib/nest-unit.rb", "test/nest-unit_test.rb", "test/test_helper.rb"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The lightest way to add contexts to Test::Unit}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
