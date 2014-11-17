# CertMunger

A gem that takes string input for X509 certificates and attempts to reformat
them into a valid certificate. This gem extends the core String class to add
the `.to_cert` and `.to_cert!` methods through the CertMunger module.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cert_munger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cert_munger

## Usage

```ruby
# Use CertMunger on any string:
new_cert = "<invalidly formatted cert string>".to_cert

# Or a string read from a file (one or multiple lines):
bad_cert = File.read(malformeed_cert_to_parse)
bad_cert.to_cert!
```

## Contributing

1. Fork it ( https://github.com/stevenhaddox/cert_munger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Ensure your changes have tests
4. Run the test suite (`bundle exec rake`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
