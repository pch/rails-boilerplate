# README

This is a Ruby on Rails project template I created to avoid having to set up the same boring stuff from scratch over and over again.

Includes:

- complete authentication (not based on 3rd-party gems)
- encryption for name, email & IP using [Active Record Encryption](https://guides.rubyonrails.org/active_record_encryption.html)
- auth activity tracking (login, logout, password reset, failed login attempts)
- city-level geocoding for IP addresses
- revokable sessions
- CSS bundling (postcss) & JS bundling (esbuild, turbo, stimulus)
- basic CSS
- sidekiq
- [hashids](https://github.com/jcypret/hashid-rails) for obfuscating sequential IDs in URLs

It is heavily based on my personal preferences and opinions, but I hope it can be a useful starting point for your apps too.

It's not a gem, not a Rails engine. It's a regular Rails project and everything is customizable. Feel free to change what you don't like and remove what you don't need.

## How to use it?

Rails Boilerplate is a project you use instead of running `rails new`. Simply click the "Use this template" button on GitHub to create your own project based on this starter.

### Configuration

After you clone the repo, use the find-and-replace in your editor to rename "boilerplate" throughout the project.

Set up initial config (for [credentials](https://edgeguides.rubyonrails.org/security.html#environmental-security) & [encryption](https://guides.rubyonrails.org/active_record_encryption.html)):

```sh
bin/rails credentials:edit
```

The command above will create a new `config/master.key` file. Don't check it into your repository. Save it in a password manager, or another safe place. Without it you won't be able to decrypt the data (names, emails & IP addresses).

(In production, use `RAILS_MASTER_KEY` environment variable instead of `config/master.key`)

To set up encryption, run this:

```sh
bin/rails db:encryption:init
```

Copy the output and add it to your credentials via `bin/rails credentials:edit`

### Initial credentials file

The initial credentials file should look like this:

```yaml
# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: <RANDOM_SECRET_STRING>

active_record_encryption:
  primary_key: <PRIMARY_KEY>
  deterministic_key: <DETERMINISTIC_KEY>
  key_derivation_salt: <SALT_STRING>

# This could be, for example, the result of SecureRandom.hex
hashid_salt: <RANDOM STRING FOR HASHID IDS>
```

### Setup database

```sh
rails db:setup
```

### Geocoding

This app uses [Geocoder](https://github.com/alexreisner/geocoder) for city-level geocoding. For perfomance and GDPR compliance, it is recommended to use a local database, which can be downloaded from the [MaxMind's website](https://dev.maxmind.com/geoip/geoip2/geolite2/) (you'll need the GeoLite2 City database).

Once you have downloaded the databse, update the `maxmind_geolite2_file` value in `config/config.yml`, pointing it to your `GeoLite2-City.mmdb` file.

---

## Upgrades

Clone your repo and add boilerplate as upstream:

```sh
git remote add boilerplate git@github.com:pch/rails-boilerplate.git
```

You can then work on your project as usual, pushing to your `main` or a feature branch. If you ever need to pull latest updates to the starter project, simply pull changes from `boilerplate`:

```sh
git fetch boilerplate
git checkout main

# create a new branch for upgrades
git checkout -b boilerplate-upgrade

# merge latest changes to your branch
# (you'll run into conflicts depending on how much you modify the base code)
git merge boilerplate/main --allow-unrelated-histories

# run tests
rails test

# merge upgrades to your main branch
git checkout main
git merge boilerplate-upgrade
git push origin main
git branch -d boilerplate-upgrade
```

You can also `cherry-pick` commits that interest you instead of merging everything.
