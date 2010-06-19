require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/cdr-fetcher'

Hoe.plugin :newgem
Hoe.plugin :git
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'cdr-fetcher' do
  self.developer 'Carl Hicks', 'carl.hicks@gmail.com'
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [['net-sftp'],['net-ssh']]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
