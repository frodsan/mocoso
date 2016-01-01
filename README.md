Mocoso [![Build Status](https://travis-ci.org/frodsan/mocoso.svg)](https://travis-ci.org/frodsan/mocoso)
======

Yet Another Simple Stub & Mock library. This is inspired by
[Minitest::Mock][minitest] and [Override][override].

Description
-----------

Mocoso meets the following criteria:

* Simplicity.
* Always restore stubbed methods to their original implementations.
* Doesn't allow to stub or mock undefined methods.
* Doesn't monkey-patch any class or object.
* Test-framework agnostic. No integration code.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "mocoso"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install mocoso
```

Usage
-----

A quick example (uses [Cutest][cutest]):

```ruby
require "cutest"
require "mocoso"

include Mocoso

test "mocking a class method" do
  user = User.new

  expect(User, :find, with: [1], return: user) do
    assert_equal user, User.find(1)
  end

  assert_equal nil, User.find(1)
end

test "stubbing an instance method" do
  user = User.new

  stub(user, :valid?, true) do
    assert user.valid?
  end

  assert !user.valid?
end
```

Check [Official Documentation][docs] for more details.

Contributing
------------

Fork the project with:

```
$ git clone git@github.com:frodsan/mocoso.git
```

To install dependencies, use:

```
$ bundle install
```

To run the test suite, do:

```
$ rake test
```

For bug reports and pull requests use [GitHub][issues].

License
-------

Mocoso is released under the [MIT License][mit].

[docs]: http://rubydoc.info/github/harmoni/mocoso/
[cutest]: https://github.com/djanowski/cutest/
[issues]: https://github.com/frodsan/mocoso/issues
[minitest]: https://github.com/seattlerb/minitest/
[mit]: http://www.opensource.org/licenses/MIT
[override]: https://github.com/soveran/override/
