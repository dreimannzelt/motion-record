module MotionRecord

  class Attribute
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
    
    attr_accessor :name, :type, :default, :required
    
    def initialize(name)
      @name = name.to_s
    end
    
    def attribute_description
      desc = NSAttributeDescription.new
      desc.name = name
      desc.defaultValue = default
      desc.attributeType = TYPE_MAPPING[type] || TYPE_MAPPING[:undefined]
      desc.optional = required
      desc
    end

  end

end