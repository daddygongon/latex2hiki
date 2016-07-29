# Latex2hiki

latex文書をhiki構造に変換するCUI.

単独のlatex fileをhiki化するだけでなく，目次にしたがって構造化されたhikiサイトを自動構築することを目指している．


|options|操作|DIR_NAME/.latex2hikiの初期値|
|:----|:----|:----|
|--init [DIR_NAME]| ベースとなるlatexサイトを構築する|
|--figures [DIR_NAME]| 下部のdirectoriesから画像ファイルを集める |fig_extension='.eps'|
|--contents| text, figuresをサイトに構築する | site = '/hoge/hoge'|


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'latex2hiki'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install latex2hiki
```

## Usage



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec latex2hiki` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/latex2hiki. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
