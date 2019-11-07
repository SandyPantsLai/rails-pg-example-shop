# Rails E-commerce Heroku Example App

This e-commerce app is built with [Solidus](https://github.com/solidusio/solidus) with Ruby 2.6.4, Rails 5 and Puma 4. It is intended to demo different best practices and use cases in the context of working with Heroku. 

The master branch contains the base e-commerce store to be deployed on the Heroku [Common Runtime](https://devcenter.heroku.com/articles/dyno-runtime#common-runtime). Future branches that remain unmerged represent different versions of this demo store, i.e. one meant for deploy on [Private Spaces](https://devcenter.heroku.com/articles/dyno-runtime#private-spaces-runtime), one that uses Sidekiq for background jobs, one to set up a scenario with bad database queries etc.

A [`free` dyno](https://devcenter.heroku.com/articles/dyno-types) will be used to run your app when you use the Deploy to Heroku button below. The following [add-ons](https://devcenter.heroku.com/articles/add-ons) will be provisioned. Only the free tiers of each are provisioned by default. You may need to upgrade these to paid plans in order to apply certain best practices, i.e. Postgres metrics are not available on the `hobby-dev` plan so you can't really monitor Postgres without upgrading. 

## Default Add-ons:

##### Necessary for App Functionality
- [Heroku Postgres](https://devcenter.heroku.com/articles/heroku-postgresql) - [`hobby-dev` plan](https://elements.heroku.com/addons/heroku-postgresql), Postgres version 11: Primary database for the app
- [Cloudinary](https://devcenter.heroku.com/articles/cloudinary) - [`starter` plan](https://elements.heroku.com/addons/cloudinary): For static assets, i.e. the product images

##### Logging and Monitoring Tools
- [Papertrail](https://devcenter.heroku.com/articles/papertrail) - [`choklad` plan](https://elements.heroku.com/addons/papertrail): Tool for searchable logs and other useful logging features 
- [New Relic](https://devcenter.heroku.com/articles/newrelic) - [`wayne` plan](https://elements.heroku.com/addons/newrelic): APM (app performance monitoring) tool 
- [Librato](https://devcenter.heroku.com/articles/librato) - [`development` plan](https://elements.heroku.com/addons/librato): Metrics dashboard tool

## Deployment

Use this button below to deploy the basic version of the store:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/SandyPantsLai/rails-pg-example-shop/tree/master)

Future branches will have their own buttons for deployment listed here so you can set up a fresh app for each situation if you wish.

## After Deployment

- You can access the customer UI at whatever-you-named-your-app.herokuapp.com.
- You can access the admin UI at whatever-you-named-your-app.herokuapp.com/admin.

## Local Development

1. Clone this repo
2. Ensure you have [Imagemagick](https://imagemagick.org/script/download.php) installed omn your machine, which is required for Paperclip.
3. Run `bundle install`
4. Now run these generators that set up config and migrations, and then run the migrations:
```
bundle exec rails g spree:install
bundle exec rails g solidus:auth:install
bundle exec rake railties:install:migrations
bundle exec rake db:migrate
```

You can now launch the app with `bundle exec rails s` and view the frontend at http://localhost:3000/. The admin UI can be found at http://localhost:3000/admin/. 

## To Do
- Add more versions of this store as new branches
- Update to Rails 6 once the new version of `solidus-auth-devise` is out (so v2.3.0+) which should include a fix for this [issue](https://github.com/solidusio/solidus_auth_devise/issues/174) preventing the app from running properly on Heroku with Rails 6.

