class Hash
  def method_missing(m, *args, &block)
    present = self.key?(m) || self.key?(m.to_s)
    super unless present

    self[m] || self[m.to_s]
  end
end

hash = {a: 1, b: 2}

puts hash.a
puts hash.b