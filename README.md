Mocoso
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

Installation
------------

```bash
$ gem install mocoso
```

[docs]: http://rubydoc.info/github/frodsan/mocoso/
[cutest]: https://github.com/djanowski/cutest/
[override]: https://github.com/soveran/override/
[minitest]: https://github.com/seattlerb/minitest/
