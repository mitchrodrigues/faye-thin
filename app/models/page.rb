class Page < Neo4jModel
  init_index :page_name
  def self.find_by_page_name(value)
    Neography::Node.find(self.name, "page_name", value)
  end
end