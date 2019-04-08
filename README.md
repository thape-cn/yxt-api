yxt-api [![Gem Version][version-badge]][rubygems]
=======

An unofficial 云学堂 http://www.yxt.com/ API wrap gem.

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
Yxt.apikey     = 'your_api_key'
Yxt.secretkey  = 'your_secret_key'
Yxt.base_url  = 'http://api.yunxuetang.com.cn' # notice no / at end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thape-cn/yxt-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


[version-badge]: https://badge.fury.io/rb/yxt-api.svg
[rubygems]: https://rubygems.org/gems/yxt-api
