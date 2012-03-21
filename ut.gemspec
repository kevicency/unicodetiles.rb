$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'ut/version'

Gem::Specification.new 'unicodetiles', UT::VERSION do |s|
  s.description       = "A simple, text character based tile engine for creating roguelike games etc. The bundled font (DejaVu Sans Mono) has decent coverage (3289 glyphs) of Unicode, providing monospace characters for various miscellaneous symbols that can be useful in creating fancy looking character based games and user interface."
  s.summary           = "Unicode Tile Engine"
  s.authors           = ["Kevin Mees"]
  s.email             = "kev.mees@gmail.com"
  s.homepage          = "https://kmees.github.com/projects/unicodetiles"
  s.files             = `git ls-files`.split("\n") - %w[.gitignore]
  s.test_files        = s.files.select { |p| p =~ /^spec\/.*_spec.rb/ }
  s.extra_rdoc_files  = s.files.select { |p| p =~ /^Readme.md/ }

  s.add_dependency 'gosu', '>= 0.7'
end
