# frozen_string_literal: true

require 'rake'
require 'yard'

desc 'Rakes the yard'
YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc']
end
