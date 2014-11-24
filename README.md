# Dominatrix

Extract the registered domain name from a URI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dominatrix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dominatrix

## Usage

### Parsing Domains

To parse a domain name from a URI, call the `Dominatrix.parse` method with a
URI object or parseable URI string.

```ruby
Dominatrix.parse('http://www.google.com')
# => "google.com"

uri = URI.parse('http://maps.google.co.uk/map?foo=bar')
Dominatrix.parse(uri)
# => "google.co.uk"

Dominatrix.parse('http://10.0.0.1')
# => Dominatrix::NotFoundError: no matching domain for "http://10.0.0.1"
```

A second parameter can alternatively be passed to define the known extensions.
This parameter should be an `Enumerable` (optimally a `Set`) in which each
extension contains the leading dot.  By default, this value is set to
`Dominatrix.default_extensions`.

```ruby
extensions = %w[.com .net .co.uk].to_set

Dominatrix.parse('http://www.google.com', extensions)
# => "google.com"

Dominatrix.parse('http://www.google.ca', extensions)
# => Dominatrix::NotFoundError: no matching domain for "http://www.google.ca"
```

If a domain is found, then a string will be returned.  Otherwise, one of the
following errors will be raised:

* `ArgumentError`: the URI param was not passed in as a `String` or `URI`, or
  the URI param does not include a host, or the extensions param was not passed
  in as an `Enumerable`.
* `URI::InvalidURIError`: the URI was passed in as a `String` and cannot be
  parsed.
* `Dominatrix::NotFoundError`: the URI does not contain a valid domain name.

### Domain Extensions

To see the list of domain extensions built into the gem, call the
`Dominatrix.default_extensions` method.

```ruby
Dominatrix.default_extensions
# => #<Set: {".ac", ".com.ac", ".gov.ac", ".mil.ac", ... }>
```

You can manually add to and remove from this list via the
[`Set#add`](http://www.ruby-doc.org/stdlib-2.1.5/libdoc/set/rdoc/Set.html#method-i-add)
([`Set#<<`](http://www.ruby-doc.org/stdlib-2.1.5/libdoc/set/rdoc/Set.html#method-i-3C-3C))
and [`Set#delete`](http://www.ruby-doc.org/stdlib-2.1.5/libdoc/set/rdoc/Set.html#method-i-delete)
methods.

```ruby
Dominatrix.default_extensions.include? '.foo'
# => false
Dominatrix.default_extensions.include? '.com'
# => true

Dominatrix.default_extensions << '.foo'
Dominatrix.default_extensions.delete('.com')

Dominatrix.default_extensions.include? '.foo'
# => true
Dominatrix.default_extensions.include? '.com'
# => false
```

## Known Issues

This gem does not currently work with domains that require right-to-left
language support.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dominatrix/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
