# ytpodcast
A simple server-side-tool that provides youtube videos as (audio-)podcasts

## Prerequisites

  * Ruby >= 2.2.2
  * Bundler (use bundle to install dependencies)
  * youtube-dl

## Configuration

  * Run `bundle install` to install dependencies
  * Copy `config-example.yml` to `config.yml` and edit it according to your needs - you can add additional channels.
  * Create a data directory which should be accessible via to webserver. Configure the `base_url` to be the base
  URL of that directory. (e.g. symlink `/var/www/podcasts` to `./data` and set `http://example.com/podcasts` as your `base_url`)

## Usage
Just run `ruby ytpodcast.rb`

## Troubleshooting
`rm -r data/` and `rm cache.json` in order to remove previously downloaded data


