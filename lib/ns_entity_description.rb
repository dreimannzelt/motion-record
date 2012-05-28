class NSEntityDescription
  TYPE_MAPPING = {
    :undefined     => NSUndefinedAttributeType,
    :string        => NSStringAttributeType,
    :date          => NSDateAttributeType,
    :decimal       => NSDecimalAttributeType,
    :float         => NSFloatAttributeType,
    :double        => NSDoubleAttributeType,
    :boolean       => NSBooleanAttributeType,
    :integer16     => NSInteger16AttributeType,
    :integer32     => NSInteger32AttributeType,
    :integer64     => NSInteger64AttributeType,
    :binary        => NSBinaryDataAttributeType,
    :transformable => NSTransformableAttributeType
  }

  def add_property(name, type = :undefined, options = {})
    attribute = NSAttributeDescription.alloc.init
    attribute.name          = name.to_s
    attribute.attributeType = TYPE_MAPPING[type] || TYPE_MAPPING[:undefined]
    attribute.defaultValue  = options[:default]
    attribute.optional      = !options[:required]
    setProperties(properties + [ attribute ])
    attribute
  end
  
  def timestamps
    add_property(:updated_at, :date, :default => Time.new)
    add_property(:created_at, :date, :default => Time.new)
  end
  
  def string(name, options = {})
    add_property(name, :string, options)
  end
  
  def integer16(name, options = {})
    add_property(name, :integer16, options)
  end
  
  def integer32(name, options = {})
    add_property(name, :integer32, options)
  end
  
  def integer64(name, options = {})
    add_property(name, :integer64, options)
  end

  def boolean(name, options = {})
    add_property(name, :boolean, options)
  end
  
  def date(name, options = {})
    add_property(name, :date, options)
  end

  def decimal(name, options = {})
    add_property(name, :decimal, options)
  end
  
  def float(name, options = {})
    add_property(name, :float, options)
  end

  def double(name, options = {})
    add_property(name, :double, options)
  end

  def binary(name, options = {})
    add_property(name, :binary, options)
  end
  
  def transformable(name, options = {})
    add_property(name, :transformable, options)
  end
    
end
