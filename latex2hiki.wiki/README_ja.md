# Latex2hiki

latex文書をhiki構造に変換するCUI.

単独のファイルを変換するlatex2hikiと，latex文書構成にしたがってhiki構造を作成するmk_maple_hikiとを提供している．

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

## latex2hiki usage

```
latex2hiki sample.tex > sample.hiki

```
## mk_maple_hiki usage
mk_maple_hikiは，目次にしたがって構造化されたhikiサイトを自動構築することを目指している．


|options|操作|DIR_NAME/.latex2hiki_rcの初期値|
|:----|:----|:----|
|--init [DIR_NAME]| ベースとなるlatexサイトを構築する，Rakefile, figures, .latex2hiki_rcを作成|
|--figures [DIR_NAME]| 下部のdirectoriesから画像ファイルを集め，pngに変換してhiki/cache/attachへ入れる． |:fig_extension: ".eps"|
|--scale [VAL]% |figuresをhikiに変換するときのscale|デフォルトは80%|
|--level [VAL] |head(!や!!)をどのlevelから始めるか．| :level: 0|
|--hiki| text, figuresをサイトに構築する | :local_site: "/hoge/hoge"|


- initで配置されるRakefileに一括変換のサンプルがある
- 変換errorや，Latex標準でないcommandはrake preで予め変換．
  - それぞれの変換の内容はRakefileを参照せよ．

以下のように切り分けているが，もっと徹底すべき．

|binのコマンド|source|内容|
|:----|:----|:----|
|latex2hiki|lib/maple/latex2hiki.rb|latexからの基本変換|
|mk_maple_hiki|lib/mk_maple_hiki.rb|directoryからhikiへの自動変換|
|rake maple|Rakefile|固有変換を自動化するサンプル|


## 具体的な使用例
### 一括して作る場合
```tcsh
bob% cd MapleText/
bob% mk_maple_hiki --init
bob% mk_maple_hiki --figures NumMaple
```
```tcsh
[bob:~/Ruby/latex2hiki/MapleText] bob% mk_maple_hiki --hiki NumMaple/
[["begin", "document"], ["title", "Mapleで理解する数値計算の基礎"], ["author", "西谷@関西学院大・理工"], ["date", "\\today"], ["chapter", "代数方程式(fsolve)"], ["section", "概要"], ["input", "FSolve/abs.tex"], ["section", "Mapleでの解"], ["input", "FSolve/s
...
["!!", "高速フーリエ変換アルゴリズムによる高速化"]
"FFT/TukeyAlgorithm.tex"
["!!", "FFT関数を用いた結果"]
"FFT/FFTFunction.tex"
chmod 666 /Users/bob/Sites/new_ist_data/maple_hiki_data/text/NumMaple
```

### sectionを分割して作る場合
```tch
bob% ls
Error/                 LAEigenvectors/        NonLinearFit/          NumMapleCont.tex       figures/
FFT/                   LAFundamentals/        NumMaple.out           NumMaple_140130.pdf
FSolve/                LAMatrixInverse/       NumMaple.tex           NumMaple_160802.pdf
InterpolationIntegral/ LeastSquareFit/        NumMaple.toc           Rakefile
bob% rake maple
"./Error"
[["begin", "document"], ["chapter", "誤差(Error)"], ["section", "打ち切り誤差と丸め誤差(Truncation and round off errors)"], ["input", "TruncationRoundoff.tex"], ["s
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec latex2hiki` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/latex2hiki. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
