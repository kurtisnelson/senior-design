# Fenway

[![Dependency Status](https://gemnasium.com/kurtisnelson/senior-design.png)](https://gemnasium.com/kurtisnelson/senior-design)
[![Code Climate](https://codeclimate.com/github/kurtisnelson/senior-design.png)](https://codeclimate.com/github/kurtisnelson/senior-design)
[![Build Status](https://secure.travis-ci.org/kurtisnelson/senior-design.png)](http://travis-ci.org/kurtisnelson/senior-design)
[![Coverage Status](https://coveralls.io/repos/kurtisnelson/senior-design/badge.png?branch=master)](https://coveralls.io/r/kurtisnelson/senior-design)

## Setting up Rails/Ruby

* Install [RVM](https://rvm.io/)
* Install Ruby 2.0 with RVM

## Getting the App Setup

```bash
# Checkout the repo
git clone git@github.com:highgroove/<project>.git

# Install gem dependencies
gem install bundler
bundle install

# Install other dependencies
brew install postgres redis

# Get the database ready
bundle exec rake db:create:all db:schema:load db:test:prepare

# Start the app and other processes

bundle exec foreman start
```

## Development

When making changes to files, make sure that your changes are consistent with
the existing style of the file. For Ruby files, these will typically follow the
Github Ruby Styleguide:

* https://github.com/styleguide/ruby

### Database setup

For example:

Grab the production database

```bash
heroku pgbackups:capture --expire
curl -o latest.dump `heroku pgbackups:url`
pg_restore -h localhost --verbose --clean --no-acl --no-owner -d
<project>_development latest.dump
rm latest.dump
```


### Testing

Explain how to run the test-suite here

## Production

* Explain how to deploy here
* Explain any addons required (for example Heroku addons)
* Explain external services being used e.g. Mailchimp, Mandrill, NewRelic, etc.

## Architecture

* List any salient architecture notes.  This should be super high-level but
  explain to future devs how things fit together
