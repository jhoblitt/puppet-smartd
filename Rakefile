require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.2')
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

PuppetSyntax.exclude_paths = ['spec/fixtures/**/*']

PuppetLint::RakeTask.new :lint do |config|
  config.pattern          = 'manifests/**/*.pp'
  config.fail_on_warnings = true
end

task :travis_lint do
  sh 'travis-lint'
end

task :default => [
  :validate,
  :lint,
  :spec,
]
