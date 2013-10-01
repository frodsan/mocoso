module Mocoso
  def stub object, methods
    metaclass = class << object; self; end

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
        methods.keys.each do |method|
          metaclass.send :undef_method, method
          metaclass.send :alias_method, method, stub_method_name(method)
          metaclass.send :undef_method, stub_method_name(method)
        end
      end
    end
  end

  def stub_method_name name
    "__mocoso_#{name}"
  end
  private :stub_method_name

  def expect object, method, options
    stub object, method => lambda { |*params|
      options[:with] = Array(options[:with])
      if params != options[:with]
        raise ExpectationError.new(options[:with], params)
      end
      options[:return]
    }
  end

  class ExpectationError < ArgumentError
    def initialize expected, actual
      super "Expected #{expected.inspect}, got #{actual.inspect}"
    end
  end
end
