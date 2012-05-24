class Project < NSManagedObject
  
  def self.entity_properties
    [
      property(:title, :string),
      property(:deadline, :date)
    ]
  end
  
end