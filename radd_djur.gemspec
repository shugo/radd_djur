require 'rubygems'
Gem::Specification.new { |s|
  s.name = "radd_djur"
  s.version = "0.0.1"
  s.date = "2013-04-20"
  s.author = "Shugo Maeda"
  s.email = "shugo@ruby-lang.org"
  s.homepage = "http://github.com/shugo/radd_djur"
  s.platform = Gem::Platform::RUBY
  s.summary = "Packrat parser combinator library for Ruby"
  s.files = Dir.glob('{lib}/**/*') + ['README.md']
  s.require_path = "lib"
  s.add_dependency("immutable", "~>0.3.1")
}
