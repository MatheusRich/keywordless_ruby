module RuntimeCasting
  def method_missing(m, *args, &block)
    name = m.to_s

    if name.start_with? 'to_'
      class_name = name.gsub('to_', '').split('_').map(&:capitalize).join
      klass = Kernel.const_get(class_name)
      
      klass.from(self)
    elsif unary_operator?(m)
      @value.public_send(m, *args)
    else
      super
    end
  end
end

def unary_operator?(method)
  %i[+ - * / += -= *= /=].include? method
end

class Currency
  include RuntimeCasting

  def initialize(value)
    @value = value
  end

  def self.from
    raise NotImplementedError.new 'A currency should implement this'
  end
end

class Usd < Currency
  def self.from(value)
    raise 'Unkown currency' unless value.is_a? Currency

    new(value * 5)
  end

  def to_s
    "$ #{@value}"
  end
end

class Brl < Currency
  def self.from(value)
    raise 'Unkown currency' unless value.is_a? Currency
    
    new(value / 5)
  end
  
  def to_s
    "R$ #{@value.to_s.gsub('.', ',')}"
  end
end

brl = Brl.new(10.00)
usd = Usd.new(10.00)

puts "brl: #{brl}"
puts "brl to usd: #{brl.to_usd}"
puts "usd: #{usd}"
puts "usd to brl: #{usd.to_brl}"