# require 'bundler/inline'

# gemfile do
#   source 'https://rubygems.org'
  # gem 'debug_inspector'
  # gem 'rubocop', require: false
# end

# require 'debug_inspector'

$main_obj = self

class Object
  def self.init(&block)
    define_method(:initialize, &block)
  end
  
  def ivar_set(name, value)
    instance_variable_set(:"@#{name}", value)
  end

  def ivar(name)
    instance_variable_get(:"@#{name}")
  end

  def def_singleton_method(name, &block)
    define_singleton_method(name, &block)
  end

  def if_true
    yield

    self
  end

  def if_false
    self
  end

  def plus(b)
    self + b
  end

  def minus(b)
    self - b
  end

  def multiply(b)
    self * b
  end

  def divide(b)
    self / b
  end

  def mod(b)
    self % b
  end


  def gt?(b)
    self > b
  end

  def gte?(b)
    self >= b
  end

  def lte?(b)
    self <= b
  end

  def lt?(b)
    self < b
  end

  def and(b)
    self && b
  end

  def or(b)
    self || b
  end

  def negated
    !self
  end
end

class FalseClass
  def if_true
    self
  end

  def if_false
    yield

    self
  end

  def negated
    !self
  end
end

class TrueClass
  def negated
    !self
  end

  def if_true
    yield

    self
  end

  def if_false
    self
  end
end

class NilClass
  def if_true
    self
  end

  def if_false
    yield

    self
  end
    def negated
    !self
  end
end

class Symbol
  def is(value)
    assign(self, value)
  end

  def to_ivar(value = nil)
    instance_variable_set("@#{self}", value)
  end
end

def defclass(name, inherits: Object, &block)
  klass = Class.new(inherits, &block)

  Kernel.const_set(name, klass)
end

def defmodule(name, &block)
  klass = Module.new(&block)

  Kernel.const_set(name, klass)
end

def defmethod(name, &block)
  define_method(name, &block)
end

def const(name, value)
  Kernel.const_set(name, value)
end

def assign(a, b)
  $main_obj.instance_variable_set("@#{a}", b)
  $main_obj.class.class_eval("attr_accessor :#{a}")

  b
end

def not(a)
  !a
end

# ##############################################################################

# Class creation

defclass :User do
  init do |name:, age:, is_crazy: true|
    ivar_set(:name, name)
    :age.to_ivar(age)
    :is_crazy.to_ivar
    @is_crazy = is_crazy
  end

  def_singleton_method :with do |*args, **kwargs|
    new(*args, **kwargs)
  end

  defmethod(:name) { @name }
end

pp User.with(name: 'Matheus', age: 22)


# Module creation
defmodule :Asdf do
  def_singleton_method :asdf do
    puts 'asdf'
  end
end

Asdf.asdf


# Assigning stuff

:a.is 1
assign(:b, 2)
const(:C, 3)

puts "a: #{a}"
# => a: 1

puts "b: #{b}"
# => b: 2

puts C
# => 3


# Bool operations

a.gt?(b)
  .if_true { puts 'a is greater' }
  .if_false { puts 'b is greater' }
# => b is greater

false.or not(true)
  .if_true { raise 'false or not true' }

true.and true.negated
  .if_true { raise 'true and not true' }
