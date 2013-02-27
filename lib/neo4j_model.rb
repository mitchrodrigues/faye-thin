class Neo4jModel < Neography::Node
  attr_accessor :primary_index
  CONNECTION = Neography::Rest.new
  include ActiveModel

  class << self

    def create(attributes)
      obj = super(attributes)
      obj.save

      CONNECTION.add_node_to_index(@primary_index,
        @primary_key.to_s,
        obj.send(@primary_key),
        obj
      )
      obj
    end

    def init_index(primary_key)
      @primary_key = primary_key
      @primary_index = self.name.downcase
      CONNECTION.create_node_index(@primary_index)
    end
  end


  def method_missing(methsym, *args)

  end
end