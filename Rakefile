require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestRake.new do |t|
	t.libs << "test"
	t.test_files = FileList['test/*test.rb']
	t.verbose = true
end
