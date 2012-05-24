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
  
  def initialize
    unless @@manager
      @@manager = MotionRecord::Manager.shared
    end
  end

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
  
  # Helper to create a property for an entity
  def self.property(name, type = :undefined, optional = true, default = nil)
    property = NSAttributeDescription.alloc.init
    property.name = name
    property.attributeType = TYPE_MAPPING[type] || TYPE_MAPPING[:undefined]
    property.optional = optional
    property.defaultValue = default
    property
  end
  
  # Helper to create a one-to-one relationship for an entity
  def self.has_one(name, target, inverse = nil)
    
  end
  
  # Helper to create a one-to-many relationship for an entity
  def self.has_many(name, target, inverse = nil)
    
  end
  
  # Create
  
  def self.create(default)
    instance = @@manager.new_object_for_name(self.to_s)
    
    instance
  end
  
  # Delete
  
  def destroy
    
  end
  
  # Find

private
  def self.create_request
    request = NSFetchRequest.alloc.init
    request.entity = MotionRecord::Manager.entity_for_name(self.to_s)
    request
  end

public  
  def self.findAll
    error = Pointer.new(:object)
    all = @@manager.executeFetchRequest(create_request, error:error)
    puts "#{error}" if all.nil?
    all
  end
  
  def self.findFirst
    error = Pointer.new(:object)
    request = create_request
    request.fetchLimit = 1
    all = @@manager.executeFetchRequest(request, error:error)
    puts "#{error}" if all.nil?
    all.first
  end
  
  # Save
  
  def save
    @@manager.save
  end

end