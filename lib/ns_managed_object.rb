class NSManagedObject
  TYPE_MAPPING = {
    :undefined     => NSUndefinedAttributeType,
    :string        => NSStringAttributeType,
    :date          => NSDateAttributeType,
    :decimal       => NSDecimalAttributeType,
    :float         => NSFloatAttributeType,
    :double        => NSDoubleAttributeType,
    :boolean       => NSBooleanAttributeType,
    :integer16     => NSInteger16AttributeType,
    :integer32     => NSInteger16AttributeType,
    :integer64     => NSInteger16AttributeType,
    :binary        => NSBinaryDataAttributeType,
    :transformable => NSTransformableAttributeType,
    :id            => NSObjectIDAttributeType
  }
  
	def self.entity
    @entity ||= begin
      entity = NSEntityDescription.alloc.init
      entity.name = entity.managedObjectClassName = self.to_s
      entity.properties = [ 
        property("created_at", :date),  
        property("updated_at", :date) 
      ] + entity_properties 
      entity
    end
	end
  
  # Subclass responsibility
  def self.entity_properties
    []
  end
  
  # Property
  
  def self.property(name, type = :undefined, optional = true, default = nil)
    property = NSAttributeDescription.alloc.init
    property.name = name.to_s
    property.attributeType = TYPE_MAPPING[type] || TYPE_MAPPING[:undefined]
    property.optional = optional
    property.defaultValue = default
    property
  end
  
  def self.has_property?(name, type)
    entity.properties.any? do |p|
      p.is_a?(NSAttributeDescription) && 
      p.name.to_s == name.to_s && 
      p.attributeType == TYPE_MAPPING[type]
    end
  end
  
  # Relationship
  
  # Helper to create a one-to-one relationship for an entity
  def self.has_one(name, target, inverse = nil)
    
  end
  
  # Helper to create a one-to-many relationship for an entity
  def self.has_many(name, target, inverse = nil)
    
  end
  
  # Create
  
  def self.create(values = { })
    instance = MotionRecord::Manager.new_object_for_name(self.to_s)
    values.each do |key, value|
      message = "set#{key.capitalize}:"
      if instance.respond_to?(message)
        instance.send("#{message}", value)
      end
    end
    instance
  end
  
  # Delete
  
  def destroy
    MotionRecord::Manager.shared.context.deleteObject self
  end
  
  # Find

private
  def self.create_request
    request = NSFetchRequest.alloc.init
    request.entity = MotionRecord::Manager.entity_for_name(self.to_s)
    request
  end

public  
  def self.find_all
    error_ptr = Pointer.new(:object)
    all = MotionRecord::Manager.shared.execute_fetch_request(create_request, error:error_ptr)
    puts "#{error}" if all.nil?
    all
  end
  
  def self.find_first
    error = Pointer.new(:object)
    request = create_request
    request.fetchLimit = 1
    all = MotionRecord::Manager.shared.execute_fetch_request(request, error:error)
    puts "#{error}" if all.nil?
    all.first
  end
  
  # Save
  
  def save
    MotionRecord::Manager.shared.save
  end

end