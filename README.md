[![Code Climate](https://codeclimate.com/github/stemps/mailsafe.png)](https://codeclimate.com/github/stemps/mailsafe)
# Mailsafe

Safe emailing for Rails. Prevents you from sending emails to real customers from non-production environments. You can choose to either re-route all emails to a single developer account or allow only recipients of your own domain.

## Installation

Add this line to your application's Gemfile:

    gem 'mailsafe'

And then execute:

    $ bundle

## Usage

You can re-route all emails to your developer email account by adding this your _development.rb_ file

```ruby
Mailsafe.setup do |config|
  config.override_receiver = "developer@devco.com"
end
```

The email subjects will be delivered to your account and prefixed with the original receiver in square brackets.


You can send emails to the intended recipients but only within your company (e.g. helpful for a staging environment)

```ruby
Mailsafe.setup do |config|
  config.allowed_domain = "devco.com"
end
```

If you are running multiple environments with _mailsafe_ it can help to know which environment an email came from. You can have _mailsafe_ prefix the subject line with _[environment name]_ 

```ruby
config.prefix_email_subject_with_rails_env = true
```


## Caveat

In order to filter (as in not send) emails I had to monkey patch the Mail#deliver method. If this makes you feel uneasy, better try out a different solution.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
