require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

#PuppetLint.configuration.send("disable_class_inherits_from_params_class")
#PuppetLint.configuration.send("disable_variable_scope")
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", 'tests/**/*.pp']

task :default => [:spec, :lint]
