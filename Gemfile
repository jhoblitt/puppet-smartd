source 'https://rubygems.org'

gem 'puppet', ENV['PUPPET_GEM_VERSION'], :require => false
gem 'facter', ENV['FACTER_GEM_VERSION'], :require => false

group :development, :test do
  # https://github.com/rspec/rspec-core/issues/1864
  gem 'rspec', '< 3.2.0', 'platforms' => ['ruby_18']
  gem 'rake', '~> 10.5',          :require => false
  gem 'puppetlabs_spec_helper',   :require => false
  gem 'puppet-lint', '>= 1.1.0',  :require => false
  gem 'puppet-syntax',            :require => false
  gem 'rspec-puppet', '~> 2.2',   :require => false
  gem 'metadata-json-lint',       :require => false
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.2')
    gem 'rubocop', :require => false
  end
end

group :beaker do
  gem 'serverspec',               :require => false
  gem 'beaker',                   :require => false
  gem 'beaker-rspec',             :require => false
  gem 'pry',                      :require => false
  gem 'travis-lint',              :require => false
  gem 'puppet-blacksmith',        :require => false
end

# vim:ft=ruby
