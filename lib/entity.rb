module MotionRecord

	class Entity      
      attr_accessor :name, :attributes, :relationships
      
      def initialize(name)
        @name = name.to_s
      end

      def attributes
        @attributes ||= [ ]
      end
      
      def relationships
        @relationships ||= [ ]
      end

	    def add_attribute(name, type = :undefined, options = {})
	      raise "You must provide a name" if name.nil?
        
	      attribute = Attribute.new(name.to_s)
	      attribute.type     = type || :undefined
	      attribute.default  = options[:default]
	      attribute.required = !options[:required]
	      attributes << attribute
	      attribute
	    end
  
	    def relationship(name)
	      properties.find { |p| p.name == name }
	    end
  
	    def add_relationship(name, options = {})
	      raise "You must provide a name" if name.nil?
	      relationship = Relationship.new(name.to_s)
	      relationship.target_class = options[:class]
	      relationship.inverse      = options[:inverse]
	      relationship.delete_rule  = options[:rule] || :no
	      relationship.min          = options[:min] || 0
	      relationship.max          = options[:max] || -1
	      relationship.ordered      = options[:ordered] || false
        relationships << relationship
	      relationship
	    end
  
	    def has_one(name, options = {})
	      raise "You must provide a name" if name.nil?
        options[:min] = 1
        options[:max] = 1
	      add_relationship(name, options)
	    end
  
	    def has_many(name, options = {})
	      raise "You must provide a name" if name.nil?
        options[:min] = 1
        options[:max] = -1
	      add_relationship(name, options)
	    end
    
	    def timestamps
	      add_attribute(:updated_at, :date, :default => Time.new)
	      add_attribute(:created_at, :date, :default => Time.new)
	    end
  
	    def string(name, options = {})
	      add_attribute(name, :string, options)
	    end
  
	    def integer16(name, options = {})
	      add_attribute(name, :integer16, options)
	    end
  
	    def integer32(name, options = {})
	      add_attribute(name, :integer32, options)
	    end
  
	    def integer64(name, options = {})
	      add_attribute(name, :integer64, options)
	    end

	    def boolean(name, options = {})
	      add_attribute(name, :boolean, options)
	    end
  
	    def date(name, options = {})
	      add_attribute(name, :date, options)
	    end

	    def decimal(name, options = {})
	      add_attribute(name, :decimal, options)
	    end
  
	    def float(name, options = {})
	      add_attribute(name, :float, options)
	    end

	    def double(name, options = {})
	      add_attribute(name, :double, options)
	    end

	    def binary(name, options = {})
	      add_attribute(name, :binary, options)
	    end
  
	    def transformable(name, options = {})
	      add_attribute(name, :transformable, options)
	    end
      
      def entity_description
        desc = NSEntityDescription.alloc.init
        desc.name = desc.managedObjectClassName = name
        attribute_descriptions = attributes.map { |a| a.attribute_description }
        desc.setProperties(attribute_descriptions)
        desc
      end
		
	end
end