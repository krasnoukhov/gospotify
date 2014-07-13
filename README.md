# GoSpotify

GoSpotify is a simple service that syncs your playlists from SoundCloud, VK and Last.fm to Spotify.

![gospotify 2014-07-13 19-37-04 2014-07-13 19-39-37](https://cloud.githubusercontent.com/assets/944286/3565170/48203002-0aac-11e4-8c1f-b68994c2200c.jpg)

## Status

[![Build Status](https://secure.travis-ci.org/krasnoukhov/gospotify.svg?branch=master)](http://travis-ci.org/krasnoukhov/gospotify?branch=master)
[![Coverage Status](https://img.shields.io/coveralls/krasnoukhov/gospotify.svg)](https://coveralls.io/r/krasnoukhov/gospotify?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/krasnoukhov/gospotify.svg)](https://codeclimate.com/github/krasnoukhov/gospotify)
[![Dependencies](https://gemnasium.com/krasnoukhov/gospotify.svg)](https://gemnasium.com/krasnoukhov/gospotify)

## Development

### Setup

* Ensure you have redis and react-tools installed
* Clone example env: ```cp .env.example .env```
* Edit ```.env``` and use it: ```source .env```
* Install fake_dynamo dependencies: ```bundle --gemfile Fakefile```
* Install application dependencies: ```bundle```

### Run

* Start foreman: ```foreman start```
* Run development server: ```lotus server```
* Run tests: ```rake```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
