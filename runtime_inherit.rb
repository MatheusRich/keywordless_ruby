class Class
  def inherit(other_class)
    add_to_ancestors(other_class)
    add_methods_of(other_class)

    self
  end

  def is_a?(other_class)
    return inherits_from?(other_class) || super(other_class)
  end

  def add_to_ancestors(other_class)
    ancestors = @__ancestors || []
    @__ancestors = ancestors + [other_class]
  end

  def inherits_from?(other_class)
    @__ancestors.include? other_class
  end

  def add_methods_of(other_class)
    raise NotImplementedError.new
  end

  # MyClass.to_module(exclude: [:private_methods, :constants])
  def to_module(exclude: [])
    raise NotImplementedError.new('Add instance, singleton methods, public and private constants')
  end
end

class A
  
end

class B
  def self.b
    puts 'self.b'
  end

  def b
    puts 'b'
  end
end

A.inherit(B)

p A.is_a? B
p A.instance_of? B
p A.is_a? Integer
# A.b
# A.new.b