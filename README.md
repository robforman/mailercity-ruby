# Mailercity

Ruby bindings for Mailercity API

## Installation

Add this line to your application's Gemfile:

    gem 'mailercity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mailercity

## Usage

Use this:
```ruby
Mailercity::UserMailer.welcome_email(:user_email => "rob@robforman.com").deliver
```

In order to send to the below mail in Mailercity:
```ruby
UserMailer.welcome_email(:user_email => "rob@robforman.com").deliver
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
