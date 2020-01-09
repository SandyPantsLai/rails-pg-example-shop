require 'pathname'
require 'store_sample'

namespace :store_sample do
  desc 'Loads sample data'
  task load_initial: :environment do
    if ARGV.include?('db:migrate')
      puts %Q{
Please run db:migrate separately from store_sample:load.
Running db:migrate and store_sample:load at the same time has been known to
cause problems where columns may be not available during sample data loading.
Migrations have been run. Please run 'rake store_sample:load' by itself now.
      }
      exit(1)
    end

    StoreSample::Engine.load_initial_samples
  end

  desc 'Generate sample orders'
  task :generate_orders, [:num_of_orders] => [:environment] do |task, args|
    StoreSample::Engine.generate_orders(args.num_of_orders.to_i)
  end
end