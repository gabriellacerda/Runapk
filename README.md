# Runapk

Runapk extends the capacity of ionic cli, providing an refined app exporting experience.

*Shortlink https://git.io/fAU5m*

## Table of Contents
 - [Introduction](#introduction)
 - [Installation](#installation)
   - [Supported Os](#supported-os)
 	- [Requirements](#requirements)
 	- [Rubygems](#rubygems)
 - [Usage](#usage)
 - [Development](#development)
 - [Contributing](#contributing)
 - [License](#license)
 - [Code of Conduct](#code-of-conduct)

## Introduction

TL;DR When working with Applications that relies on ionic sometimes you get stuck with a thousands of commands and folder navigation, Runapk comes to solve this problem combining all these steps into a refined exporting experience, stop browsing folders & running multiple commands!

Just run ``runapk`` :D and you're ready to go!

## Installation
### Supported OS
- Mac
- Windows 10 (Using linux kernel)
- Linux
### Requirements
- Cordova
- Ionic CLI
- Ruby
- Jarsigner (Install java sdk, add it to your path then you should be fine.)
- Zipalign (Install android sdk, add a build tools version folder to your path then you should be fine)
### Rubygems

Install it yourself as:

```sh
gem install Runapk
```

## Usage

1. Generate a Keystore

> If your already have a kestore skip to step 2

```
keytool -genkey -v -keystore my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
```

2. In your project root folder run

```
runapk
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabriellacerda/runapk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Runapk project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/gabriellacerda/runapk/blob/master/CODE_OF_CONDUCT.md).
