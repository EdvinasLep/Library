require "rake"
require "active_record"
require "rspec/core/rake_task"
require_relative "db/db"

def migration_context
  ActiveRecord::MigrationContext.new("db/migrate")
end

namespace :db do
  task :migrate do
    migration_context.migrate
  end

  task :rollback do
    migration_context.rollback
  end

  task :version do
    puts migration_context.current_version
  end
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec