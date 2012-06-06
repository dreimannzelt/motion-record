module MotionRecord

	class Version
    
    class << self
      
      attr_accessor :versions
       
      def versions
        @versions ||= [ ]
      end
      
      def define(number, &proc)
        last = versions.last
        base_entities = [ ]
        base_entities = last.entities if !last.nil? && !last.entities.nil?
        v = Version.new(number, base_entities)
        proc.call(v)
        versions << v
      end
      
      def build_models
        models = [ ]
        entity_descriptions = [ ]
        versions.each do |v|
          last_entities = []
          last_entities = models.last.entities if !models.last.nil? && !models.last.entities.nil?
          model = v.build_model(last_entities)
          
          version_identifiers = NSSet.setWithObject(v.number)
          if !models.last.nil? && !models.last.versionIdentifiers.nil?
            version_identifiers = version_identifiers.setByAddingObjectsFromSet(models.last.versionIdentifiers)
          end
          model.setVersionIdentifiers(version_identifiers) if !model.nil?
          models << model
        end
        models
      end
          
    end
    
    attr_accessor :entities
    
    def initialize(number, base_entites)
      @number = number
      @entities = [ ] + base_entites
    end
    
    def number
      @number
    end
    
    def entities
      @entities ||= [ ]
    end
                    
    def is_compatible_with?(meta_data)
      isConfiguration(nil, compatibleWithStoreMetadata:meta_data)
    end
    
    def entity_for_name(name)
      entities.find { |e| e.name.to_s == name.to_s }
    end
    
    def add_entity(entity)
      entities << entity
    end

    def remove_entity(entity)
      entities.delete(entity)
    end

    def create_entity(name, &proc)
      raise ArgumentError, "You must provide a name" if name.nil?
      raise ArgumentError, "You must provide a block" unless block_given?

      entity = Entity.new(name)
      add_entity(entity)
      proc.call(entity)
      entity
    end
    
    def entity(name, &proc)
      raise ArgumentError, "You must provide a name" if name.nil?
      raise ArgumentError, "You must provide a block" unless block_given?
      
      entity = entity_for_name(name.to_s)
      raise "Could not find a entity for the name #{name}" if entity.nil?
      proc.call(entity)
    end

    def drop_entity(name)
      raise ArgumentError, "You must provide a name" if name.nil?
      entity = entity_for_name(name.to_s)
      
      raise ArgumentError, "An entity with the name '#{name}' could not be found" if entity.nil?
      remove_entity(entity)
    end
    
    def build_model(entity_descriptions)
      # Build entity descriptions
      entity_descriptions = entities.map { |e| e.entity_description }
      # Build relationships with the created entity descriptions
      relationship_descriptions = [ ]
      entities.each do |e|
        e.relationships do |r|
          r_desc = relationship_description_for(r, entity_descriptions)
          entity_desc = entity_descriptions.find { |e_desc| e_desc.name.to_s == e.name }
          entity_desc.setProperties(entity.properties + [ r_desc ])
          relationship_descriptions << r_desc
        end
      end
      # Setup inverse relationships with the created relationship descriptions
      relationship_descriptions.each do |r|
         desc.inverseRelationship = relationship_descriptions.find { |r_desc| r_desc.name.to_s == relationship.inverse.to_s }
      end
      # Build core data model
      model = NSManagedObjectModel.new
      model.setEntities(entity_descriptions)
      model
    end
    
    def relationship_description_for(relationship, entity_descriptions)
      desc = NSRelationshipDescription.new
      desc.name = relationship.name
      desc.minCount = relationship.min
      desc.maxCount = relationship.max
      desc.ordered = relationship.ordered
      desc.deleteRule = relationship.delete_rule
      desc.destinationEntity = entity_descriptions.find { |e| e.name.to_s == e.target_class.to_s }
    end
    
	end
	
end