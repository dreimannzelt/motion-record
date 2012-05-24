class Task < NSManagedObject
  
  def self.entity_properties
    [
      property(:title, :string),
      property(:priority, :integer16)
    ]
  end
  
end