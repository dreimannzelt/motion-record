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
  
  class << self
        
  	def entity_description
      @entity_description ||= begin
        desc = NSEntityDescription.alloc.init
        desc.name = desc.managedObjectClassName = self.to_s
        desc.properties = [ 
          property("created_at", :date, true, Time.new),
          property("updated_at", :date, true, Time.new) 
        ] + entity_properties 
        desc
      end
  	end
  
    def entity_properties
      @entity_properties ||= []
    end
      
    def has_one(name, target, inverse = nil)
      
    end
  
    def has_many(name, target, inverse = nil)
      
    end
    
    def property(name, type = :undefined, optional = true, default = nil)
      property = NSAttributeDescription.alloc.init
      property.name = name.to_s
      property.attributeType = TYPE_MAPPING[type] || TYPE_MAPPING[:undefined]
      property.optional = optional
      property.defaultValue = default
      property
    end
  
    def has_property?(name, type)
      entity_description.properties.any? do |p|
        p.is_a?(NSAttributeDescription) && 
        p.name.to_s == name.to_s && 
        p.attributeType == TYPE_MAPPING[type]
      end
    end
  
    def create(values = { })
      new_entity = MotionRecord::Manager.new_object_for_name(self.to_s)
      values.each do |key, value|
        message = "set#{key.capitalize}:"
        if new_entity.respond_to?(message)
          new_entity.send("#{message}", value)
        end
      end
      new_entity
    end
  
  end

private
  def self.create_request
    request = NSFetchRequest.alloc.init
    request.entity = MotionRecord::Manager.entity_for_name(self.to_s)
    request
  end

public

  class << self
    
    def find(object_id)
      return nil if object_id.nil?
    
      error_ptr = Pointer.new(:object)
      entity = MotionRecord::Manager.instance.context.existingObjectWithID(object_id, error:error_ptr)
      puts "#{error_ptr[0]}" if entity.nil?
      entity
    end

    def all
      error_ptr = Pointer.new(:object)
      all = MotionRecord::Manager.instance.execute_fetch_request(create_request, error:error_ptr)
      puts "#{error_ptr[0]}" if all.nil?
      all
    end
  
    def where(expression = nil, *args)
      error_ptr = Pointer.new(:object)
      request = create_request
      request.predicate = NSPredicate.predicateWithFormat(expression, args)
      entities = MotionRecord::Manager.instance.execute_fetch_request(request, error:error_ptr)
      puts "#{error_ptr[0]}" if entities.nil?
      entities    
    end
    
    def count
      error_ptr = Pointer.new(:object)
      count = MotionRecord::Manager.instance.context.countForFetchRequest(create_request, error:error_ptr)
      puts "#{error_ptr[0]}" if error_ptr[0].nil?
      count
    end
    
    def order(name, ascending = true)
      error_ptr = Pointer.new(:object)
      request = create_request
      request.sortDescriptors = [ NSSortDescriptor.sortDescriptorWithKey(name, ascending:ascending) ]
      entities = MotionRecord::Manager.instance.execute_fetch_request(request, error:error_ptr)
      puts "#{error_ptr[0]}" if entities.nil?
      entities
    end

  end
  
  # Save
  
  def save
    MotionRecord::Manager.instance.save
  end
  
  # Delete
  
  def destroy
    MotionRecord::Manager.instance.context.deleteObject self
  end
  
end