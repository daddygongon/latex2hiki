# Latex2hiki

latex文書をhiki構造に変換するCUI.

単独のlatex fileをhiki化するだけでなく，目次にしたがって構造化されたhikiサイトを自動構築することを目指している．


|options|操作|DIR_NAME/.latex2hiki_rcの初期値|
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
- 全体を一度に作るか，部分に分けるか
- initで配置されるRakefileに一括変換のサンプルがある
- 変換errorや，Latex標準でないcommandはrake preで予め変換．
  - それぞれの変換の内容はRakefileを参照せよ．

以下のように切り分けているが，もっと徹底すべき．

|binのコマンド|source|内容|
|:----|:----|:----|
|latex2hiki|lib/maple/latex2hiki.rb|latexからの基本変換|
|mk_maple_hiki|lib/mk_maple_hiki.rb|directoryからhikiへの自動変換|
|rake maple|Rakefile|固有変換を自動化するサンプル|


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec latex2hiki` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/latex2hiki. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
