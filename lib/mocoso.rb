# Yet Another Simple Stub & Mock library, that also:
#
#   - Always restore stubbed methods to their original implementations.
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
#
#       expect User, :find, with: [1], return: user do
#         assert_equal user, User.find(1)
#       end
#     end
#
#     test 'stubbing an instance method' do
#       user = User.new
#
#       stub user, valid?: true do
#         assert user.valid?
#       end
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
  #   Mocoso.expect object, :method, with: 'argument', returns: nil do
  #     object.method 'unexpected argument'
  #     # => Mocoso::ExpectationError: Expected ["argument"], got ["unexpected argument"]
  #   end
  #
  ExpectationError = Class.new StandardError

  # Rewrites each method from +methods+ and defined in +object+. +methods+ is a
  # Hash that represents stubbed method name symbols as keys and corresponding
  # return values as values. The methods are restored after the given +block+
  # is executed.
  #
  #   signup = SignupForm.new params[:user]
  #
  #   signup.valid? # => false
  #   signup.save   # => false
  #
  #   Mocoso.stub signup, valid?: true, signup: true do
  #     signup.valid? # => true
  #     signup.save   # => true
  #   end
  #
  # You can pass a callable object (responds to +call+) as a value:
  #
  #   Mocoso.stub subject, foo: -> { "foo" }, bar: ->(value) { value } do
  #     subject.foo        # => "foo"
  #     subject.bar('foo') # => "foo"
  #   end
  #
  # If you try to stub a method that is not defined by the +object+,
  # it raises an error.
  #
  #   Mocoso.stub Object.new, undefined: nil
  #   # => NameError: undefined method `undefined' for class `Object'
  #
  def stub object, methods, &block
    metaclass = object.singleton_class

    methods.each do |method, result|
      metaclass.send :alias_method, stub_method_name(method), method

      if result.respond_to?(:call)
        metaclass.send(:define_method, method) { |*args| result.(*args) }
      else
        metaclass.send(:define_method, method) { result }
      end
    end

    begin
      yield
    ensure
      methods.keys.each do |method|
        metaclass.send :undef_method, method
        metaclass.send :alias_method, method, stub_method_name(method)
        metaclass.send :undef_method, stub_method_name(method)
      end
    end
  end

  def stub_method_name name
    "__mocoso_#{name}"
  end
  private :stub_method_name

  # Expect that method +method+ is called with the arguments specified in the
  # +:with+ option (defaults to +[]+ if it's not given) and returns the value
  # specified in the +:returns+ option. If expectations are not met, it raises
  # Mocoso::ExpectationError error. It uses #stub internally, so it will restore
  # the methods to their original implementation after the +block+ is executed.
  #
  #   class User < Model
  #   end
  #
  #   user = User[1]
  #
  #   Mocoso.expect user, :update, with: [{ name: 'new name' }], returns: true
  #     subject.update unexpected: nil
  #     # => Mocoso::ExpectationError: Expected [{:name=>"new name"}], got [{:unexpected=>nil}]
  #
  #     user.update name: 'new name'
  #     # => true
  #   end
  #
  def expect object, method, with: [], returns:, &block
    expectation = -> *params {
      raise ExpectationError, "Expected #{with}, got #{params}" if params != with
      returns
    }

    stub object, method => expectation, &block
  end
end
