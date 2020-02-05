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

  desc 'Generate batches of promo codes'
  task :generate_promo_code_batches, [
    :promo_name,
    :base_code, 
    :number_of_codes, 
    :per_code_usage_limit
  ] => [:environment] do |task, args|
    StoreSample::Engine.generate_promo_code_batches(
      args.promo_name,
      args.base_code,
      args.number_of_codes.to_i,
      args.per_code_usage_limit.to_i
    )
  end
end