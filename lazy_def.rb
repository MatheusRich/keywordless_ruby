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

  adjective do |what|
    @name + ' is ' + what
  end

  nationality(singleton: true) do
    'Brazilian'
  end
end

pp Me.new.adjective 'crazy'
pp Me.nationality