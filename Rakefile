require 'rake'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('pkg/*')

namespace :test do

  basedir = File.expand_path(File.dirname(__FILE__))

  Rake::TestTask.new do |t|
    t.name = 'test'
    t.test_files = [
      sprintf('%s/circular_array.rb', basedir),
      sprintf('%s/primes.rb', basedir)
    ]
    t.verbose = false
  end

end
desc 'run all tests'
task :test => ['test:test'] do; end