module IVarMissing
  def method_missing(m, *args, &block)
    name = m.to_s

    if name.start_with? 'set_'
      instance_variable_set('@' + name.gsub('set_', '').delete('='), *args)
    elsif name.start_with? 'get_'
      instance_variable_get('@' + name.gsub('get_', '') )
    else
      super
    end
  end
end


class A
  include IVarMissing
end

a = A.new
a.set_asdf = 1
pp a.get_asdf
