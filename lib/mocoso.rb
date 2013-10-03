# Yet Another Simple Stub & Mock library, that also:
#
#   - Provides features to restore stubbed methods to their original implementations.
#   - Doesn't allow to stub or mock undefined methods.
#   - Doesn't monkey-patch any class or object.
#   - Test-framework agnostic (Doesn't need integration code).
#
# == Setup
#
# Execute:
#
#   gem install mocoso
#
# == Usage
#
# Quick start:
#
#     require 'cutest'
#     require 'mocoso'
#
#     include Mocoso
#
#     test 'mocking a class method' do
#       user = User.new
#       expect User, :find, with: [1], return: user
#       assert_equal user, User.find(1)
#     end
#
#     test 'stubbing an instance method' do
#       user = User.new
#       stub user, valid?: true
#       assert user.valid?
#     end
#
# Note: this example uses the test framework Cutest[1]:
#
# Mocoso is stolen from Override[2], Minitest::Mock[3] and Mocha[4].
#
# * [1]: https://github.com/djanowski/cutest/
# * [2]: https://github.com/soveran/override/
# * [3]: https://github.com/seattlerb/minitest/
# * [4]: https://github.com/freerange/mocha/
#
module Mocoso
  # Raised by #expect when a expectation is not fulfilled.
  #
  #   Mocoso.expect object, :method, with: 'argument', returns: nil
  #
  #   object.method 'unexpected argument'
  #   # => Mocoso::ExpectationError: Expected ["argument"], got ["unexpected argument"]
  #
  ExpectationError = Class.new StandardError

  # Rewrites each method from `methods` and defined in +object+. `methods` is a
  # Hash that represents stubbed method name symbols as keys and corresponding
  # return values as values.
  #
  #   signup = SignupForm.new params[:user]
  #
  #   signup.valid? # => false
  #   signup.save   # => false
  #
  #   Mocoso.stub signup, valid?: true, signup: true
  #
  #   signup.valid? # => true
  #   signup.save   # => true
  #
  # You can pass a callable object (responds to +call+) as a value:
  #
  #   Mocoso.stub subject, foo: -> { "foo" }, bar: ->(value) { value }
  #
  #   subject.foo        # => "foo"
  #   subject.bar('foo') # => "foo"
  #
  # If you try to stub a method that is not defined by the +object+,
  # it raises an error.
  #
  #   Mocoso.stub Object.new, undefined: nil
  #   # => NameError: undefined method `undefined' for class `Object'
  #
  # Note that it will rewrite the method(s) in +object+. If you want to stub a
  # method without side effects, you should pass a block.
  #
  #   User.all.length
  #   # => 5
  #
  #   Mocoso.stub User, all: [] do
  #     User.all.length
  #     # => 0
  #   end
  #
  #   User.all.length
  #   # => 5
  #
  def stub object, methods
    metaclass = object.singleton_class

    methods.each do |method, result|
      metaclass.send :alias_method, stub_method_name(method), method
      metaclass.send :define_method, method do |*args|
        result.respond_to?(:call) ? result.call(*args) : result
      end
    end

    if block_given?
      begin
        yield
      ensure
        unstub object, methods.keys
      end
    end
  end

  # Removes the specified stubbed +methods+ (added by calls to #stub or #expect) and
  # restores the original behaviour of the methods before they were stubbed.
  #
  #   object.foo # => "foo"
  #
  #   Mocoso.stub object, foo: 'new foo'
  #   object.foo # => "new foo"
  #
  #   Mocoso.unstub object, [:foo]
  #   object.foo #=> "foo"
  #
  # I personally use a block on #stub or #expect to avoid side effects, because if
  # you #unstub a method which still has unsatisfied expectations, you may be
  # removing the only way those expectations can be satisfied. Use it on your
  # own responsibility.
  #
  # This method was born as a helper for #stub.
  #
  def unstub object, methods
    metaclass = object.singleton_class

    methods.each do |method|
      metaclass.send :undef_method, method
      metaclass.send :alias_method, method, stub_method_name(method)
      metaclass.send :undef_method, stub_method_name(method)
    end
  end

  def stub_method_name name
    "__mocoso_#{name}"
  end
  private :stub_method_name

  # Expect that method +method+ is called with the arguments specified in the
  # +:with+ option (defaults to +[]+ if it's not given) and returns the value
  # specified in the +:return+ option. If expectations are not met, it raises
  # Mocoso::ExpectationError error.
  #
  #   class User < Model
  #   end
  #
  #   user = User[1]
  #
  #   Mocoso.expect user, :update, with: [{ name: 'new name' }], returns: true
  #
  #   subject.update unexpected: nil
  #   # => Mocoso::ExpectationError: Expected [{:name=>"new name"}], got [{:unexpected=>nil}]
  #
  #   user.update name: 'new name'
  #   # => true
  #
  # Note that it will rewrite the method in +object+. If you want to set an
  # expectation without side effects, you should pass a block.
  #
  #   User.exists? 1
  #   # => false
  #
  #   Mocoso.expect User, :exists?, with: [1], returns: true do
  #     User.exists? 1
  #     # => true
  #   end
  #
  #   User.exists? 1
  #   # => false
  #
  def expect object, method, options
    expectation = -> *params {
      with = options.fetch(:with) { [] }

      raise ExpectationError, "Expected #{with}, got #{params}" if params != with

      options[:return]
    }

    if block_given?
      stub object, method => expectation, &proc
    else
      stub object, method => expectation
    end
  end
end
