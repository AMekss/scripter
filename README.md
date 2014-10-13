# Scripter

Library for reducing of boilerplate in ruby scripts with possibility to run fault tolerant iterations, for example mass notifications, or support scripts

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scripter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scripter

## Usage

Usage example:
```ruby
class MyScriptClass < Scripter::Base
  #ENV variables which will be assigned to instance
  env_variables :test_env

  def execute
    # your specific execution code goes here
    # Note: use #perform_iteration helper with block in order to make fault tolerant iterations
  end

  def on_exit
    # your reporting scripts goes here
    # Note: #valid?, invalid?, #errors_grouped and #errors_count methods can be useful here
  end
end
```

Call example:
```ruby
MyScripterEnabledClass.execute
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scripter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
