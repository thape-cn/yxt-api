yxt-api [![Gem Version][version-badge]][rubygems]
=======

An unofficial 云学堂 http://www.yxt.com/ API wrap gem.

## Official document

https://open.yunxuetang.cn/#/document?&id=1641790366267643906

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yxt-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yxt-api

## Usage

### Config

Create `config/initializers/yxt-api.rb` and put following configurations into your Rails project.

```ruby
Yxt.app_id          = 'your_app_id'
Yxt.app_secret      = 'your_app_secret'
Yxt.base_url        = 'https://openapi.yunxuetang.cn' # notice no / at end
Yxt.token_url       = 'https://openapi.yunxuetang.cn' # optional, default same as base_url
Yxt.token_cache_file = '/tmp/yxt-access-token-your_app_id.json' # optional
```

`Yxt.request` will automatically fetch `accessToken` from `/token`, cache it in a local temp file, and refresh it when expired.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thape-cn/yxt-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


[version-badge]: https://badge.fury.io/rb/yxt-api.svg
[rubygems]: https://rubygems.org/gems/yxt-api
