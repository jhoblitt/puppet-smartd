source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'rake',                   :require => false
gem 'puppetlabs_spec_helper', :require => false
gem 'puppet-lint',            :require => false
gem 'puppet-syntax',          :require => false
# The verify_contents method invocations have been updated to work with
# rspec-puppet 1.0.1+ but are now incompatible with <= 1.0.1
# https://github.com/rodjek/rspec-puppet/issues/235
gem 'rspec-puppet',
  :git => 'https://github.com/rodjek/rspec-puppet.git',
  :ref => '6ac97993fa972a15851a73d55fe3d1c0a85172b5',
  :require => false
# rspec 3 spews warnings with rspec-puppet 1.0.1
gem 'rspec-core', '~> 2.0',   :require => false

# vim:ft=ruby
