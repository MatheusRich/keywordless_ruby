def assert(a)
  raise 'F' unless a
end

module LazyDef
  HasSingletonMethodOption = ->(*args) do
    options = args.find { |a| a.is_a? Hash }
    return if options.nil? || options.empty?

    options[:singleton]
  end
  private_constant :HasSingletonMethodOption

  def method_missing(name, *args, &block)
    if HasSingletonMethodOption[*args]
      define_singleton_method(name, &block)
    else
      define_method(name, &block)
    end
  end

end

class Me
  extend LazyDef

  def initialize
    @name = 'Matheus'
  end

  say_hey do
    puts 'Hey!'
  end

  is do |what|
    @name + ' is ' + what
  end

  nationality(singleton: true) do
    'Brazilian'
  end
end

me = Me.new

me.say_hey
# => Hey!

puts me.is 'crazy'
# => "Matheus is crazy"

puts Me.nationality
# => "Brazilian"