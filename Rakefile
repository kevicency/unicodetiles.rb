require 'rspec/core/rake_task'
require 'rake/clean'

desc 'Default: run specs.'
task :default => :spec


# ROCCO =============================================

# Bring in Rocco tasks
require 'rocco/tasks'
Rocco::make 'docs/'

desc 'Build rocco docs'
task :docs => :rocco
directory 'docs/'

desc 'Build docs and open in browser for the reading'
task :read => :docs do
  sh 'open docs/lib/ut.html'
end

# Make index.html a copy of ut.html
file 'docs/index.html' => 'docs/lib/ut.html' do |f|
  cp 'docs/lib/ut.html', 'docs/index.html', :preserve => true
end
task :docs => 'docs/index.html'
CLEAN.include 'docs/index.html'

# Alias for docs task
task :doc => :docs

# GITHUB PAGES =======================================

desc 'Update gh-pages branch'
task :pages => ['docs/.git', :docs] do
  rev = `git rev-parse --short HEAD`.strip
  Dir.chdir 'docs' do
    sh "git add *.html"
    sh "git commit -m 'rebuild pages from #{rev}'" do |ok,res|
      if ok
        verbose { puts "gh-pages updated" }
        sh "git push -q o HEAD:gh-pages"
      end
    end
  end
end

# Update the pages/ directory clone
file 'docs/.git' => ['docs/', '.git/refs/heads/gh-pages'] do |f|
  sh "cd docs && git init -q && git remote add o ../.git" if !File.exist?(f.name)
  sh "cd docs && git fetch -q o && git reset -q --hard o/gh-pages && touch ."
end
CLOBBER.include 'docs/.git'

# RSPEC =============================================

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  # Put spec opts in a file named .rspec in root
end
