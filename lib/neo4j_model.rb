class Neo4jModel < Neography::Node
  def create(attributes)
    puts "Calling Create: #{attributes.inspect}"
    super(attributes)
    self.save
  end

  def new(attributes)
    puts "Calling new:"
    self.superclass.send(:create, attributes)
  end

end