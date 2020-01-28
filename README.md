# Rails E-commerce Heroku Example App

This e-commerce app with sample data is built with [Solidus](https://github.com/solidusio/solidus) with Ruby 2.6.4, Rails 5 and Puma 4 and Sidekiq. It is intended to demo different best practices and use cases in the context of working with Heroku. 

The master branch contains the core e-commerce store to be deployed on the Heroku [Common Runtime](https://devcenter.heroku.com/articles/dyno-runtime#common-runtime). Future branches that remain unmerged represent different versions of this demo store, i.e. with `pgbouncer`.

A [`free` (if used in Personal account) or `standard-1x` (if app created in Enterprise Team) dyno](https://devcenter.heroku.com/articles/dyno-types) will be used to run your app when you use the Deploy to Heroku button below. A `free`/`standard-1x` worker dyno is also used, though you need to scale this up manually after deployment. 

The following [add-ons](https://devcenter.heroku.com/articles/add-ons) will be provisioned when deployed with the button below. Only the free tiers of each are provisioned by default. You may need to upgrade these to paid plans in order to apply certain best practices, i.e. Postgres metrics are not available on the `hobby-dev` plan so you can't really monitor Postgres without upgrading. 

## Default Add-ons:

##### Necessary for App Functionality
- [Heroku Postgres](https://devcenter.heroku.com/articles/heroku-postgresql) - [`hobby-dev` plan](https://elements.heroku.com/addons/heroku-postgresql), Postgres version 11: Primary database for the app
- [Cloudinary](https://devcenter.heroku.com/articles/cloudinary) - [`starter` plan](https://elements.heroku.com/addons/cloudinary): For static assets, i.e. the product images
- [Heroku Redis](https://devcenter.heroku.com/articles/heroku-redis) - [`hobby-dev` plan](https://elements.heroku.com/addons/heroku-redis) used by Sidekiq

##### Logging and Monitoring Tools
- [Papertrail](https://devcenter.heroku.com/articles/papertrail) - [`choklad` plan](https://elements.heroku.com/addons/papertrail): Tool for searchable logs and other useful logging features 
- [New Relic](https://devcenter.heroku.com/articles/newrelic) - [`wayne` plan](https://elements.heroku.com/addons/newrelic): APM (app performance monitoring) tool 
- [Librato](https://devcenter.heroku.com/articles/librato) - [`development` plan](https://elements.heroku.com/addons/librato): Metrics dashboard tool

## Deployment

Use this button below to deploy the *core* version of the store.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/SandyPantsLai/rails-pg-example-shop/tree/master)

Each branch also has its own button for deployment listed on their respective READMEs.

## After Deployment

- Run the following to get more metrics:
  - `heroku labs:enable "log-runtime-metrics" -a whatever-you-named-your-app`
  - `heroku labs:enable "runtime-heroku-metrics" -a whatever-you-named-your-app`
  - `heroku labs:enable "ruby-language-metrics" -a whatever-you-named-your-app`
  - `heroku labs:enable "runtime-dyno-metadata" -a whatever-you-named-your-app`
- You can access the customer UI at whatever-you-named-your-app.herokuapp.com.
- You can access the admin UI at whatever-you-named-your-app.herokuapp.com/admin. Check your config vars for credentials.

### Important Endpoints

- `/admin/addresses` (`/admin/addresses?q%5Bcreated_since_x_days%5D=<num of days>`) This is a slow transaction that queries using a sequential scan. You can create more addresses quickly by [generating fake orders](https://github.com/SandyPantsLai/rails-pg-example-shop#fake-orders-and-send-traffic)

### If you want to use background jobs... 
- Run `heroku ps:scale worker=1` to start your Sidekiq worker. This is only used for the CSV feature, i.e. https://your-app-name.herokuapp.com/admin/csvs, so no need to scale this up if you aren't going to use that feature. The CSV import allows you to import more products - see [here for an example file](https://github.com/SandyPantsLai/rails-pg-example-shop/tree/master/db/samples/2018-sets.csv)

### Fake data and send traffic
- You can generate more fake orders if you'd like by using `heroku run bash` and then `bundle exec rake store_sample:generate_orders[number of orders to generate]` in the one-off dyno
- You may want to simulate some traffic so you can see more stuff in New Relic and Librato. A quick way is to use Apache Benchmarking (i.e. ab -n 50000 -c 50 https://your-app-name.herokuapp.com/ will send 50000 requests from 50 concurrent users to that URL) 
- If you want to simulate more than 50 concurrent users, you may want to use a load testing tool like loader.io instead. See setup instructions [here](https://github.com/SandyPantsLai/rails-pg-example-shop/tree/master/docs/loaderio-setup.md). 
- You could also deploy [this](https://github.com/tsykoduk/Mjolnir) as a separate Heroku app, update `TARGETS` with your app's endpoints and scale up its workers to send traffic.

## Local Development

1. Clone this repo and cd into the directory
2. Ensure you have [Imagemagick](https://imagemagick.org/script/download.php) installed own your machine, which is required for Paperclip.
3. Run `bundle install` and `bundle exec rake db:create`
4. Now run these generators that set up config, and then run the migrations:
```
bundle exec rails g spree:install
bundle exec rails g solidus:auth:install
bundle exec rake db:migrate
```
If you are using the CSV import feature:
5. `export CLOUDINARY_URL=<your Cloudinary info here>`
6. `brew install redis` if you don't have Redis installed
7. Run `redis-server` in your console
8. Run Sidekiq in another tab in your console with `bundle exec sidekiq`

You can now launch the app with `bundle exec puma -C config/puma.rb` and view the frontend at http://localhost:3000/. The admin UI can be found at http://localhost:3000/admin/. 

If you want to customize Solidus, see their [docs](https://guides.solidus.io/developers/customizations/overview.html). This is an example of [adding a new route](https://github.com/solidusio/solidus/issues/1704#issuecomment-303092098).

## Special Notes

Sample data and images were originally retrieved from [Rebrickable](https://rebrickable.com). If you import your own CSV file of products with a `set_num` column, the worker will try to fetch the set image from Rebrickable and upload that to Cloudinary to create your product images.

## To Do
- Add more versions of this store as new branches
- Update to Rails 6 once the new version of `solidus-auth-devise` is out (so v2.3.0+) which should include a fix for this [issue](https://github.com/solidusio/solidus_auth_devise/issues/174) preventing the app from running properly on Heroku with Rails 6.