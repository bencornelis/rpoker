require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.verbose = false
end

RSpec::Core::RakeTask.new(:integration_spec) do |t|
  t.pattern = 'spec/integration/*_spec.rb'
  t.verbose = false
end

task :default => :spec
task :integration => :integration_spec

# wget -P ./spec/fixtures http://archive.ics.uci.edu/ml/machine-learning-databases/poker/poker-hand-testing.data
