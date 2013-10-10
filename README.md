Mocoso
======

Yet Another Simple Stub & Mock library. This is stolen from tools such as
[Minitest::Mock][minitest], [Override][override] and [Mocha][mocha].

Motivation
----------

**tl;dr: Il mío capriccio**

Yes, there are a lot of good libraries out there, but I wanted one that
meets the following criteria:

* Always restore stubbed methods to their original implementations.
* Doesn't allow to stub or mock undefined methods.
* Doesn't monkey-patch any class or object.
* Test-framework agnostic (Doesn't need integration code).

And the most important: simplicity.

Installation
------------

    $ gem install mocoso

Usage
-----

A quick example (uses [Cutest][cutest]):

    require 'cutest'
    require 'mocoso'

    include Mocoso

    test 'mocking a class method' do
      user = User.new

      expect User, :find, with: [1], returns: user do
        assert_equal user, User.find(1)
      end
    end

    test 'stubbing an instance method' do
      user = User.new

      stub user, valid?: true do
        assert user.valid?
      end
    end

Check [Official Documentation][docs] for more details.

License
-------

Copyright (c) 2013 Francesco Rodríguez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[docs]: http://rubydoc.info/github/frodsan/mocoso/
[cutest]: https://github.com/djanowski/cutest/
[override]: https://github.com/soveran/override/
[minitest]: https://github.com/seattlerb/minitest/
[mocha]: https://github.com/freerange/mocha/
