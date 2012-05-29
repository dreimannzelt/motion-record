module MotionRecord

	class Migration < NSManagedObjectModel
    
    class << self
      
      attr_accessor :migration_classes
      
      def migration_classes
        @migration_classes ||= []
      end
    
      def register_migration(klass)
        migration_classes << klass
        sort_migration_classes
      end
      
      def sort_migration_classes
        migration_classes.sort! do |a, b|
          a.version_number <=> b.version_number
        end
      end

      def version(number)
        @@version_number = number
      end
      def version_number
        @@version_number
      end

      def inherited(klass)
        register_migration(klass)
      end
      
      def all_migrations
        @all_migrations ||= migration_classes.map do |klass|
          raise "Could not find a version in #{klass}. Please use Migration#version to define a version number." if klass.version_number.nil?
          m = klass.new
          m.migrate
          m
        end
      end
      
      def neweset_migration
        all_migrations.last
      end
      
    end
    
    attr_accessor :mapping_model
                
    def is_compatible_with?(meta_data)
      isConfiguration(nil, compatibleWithStoreMetadata:meta_data)
    end

    def create_entity(name, &proc)
      raise ArgumentError, "Please provide a name for the entity to create" if name.nil?
      raise ArgumentError, "Please provide a block which describes the entity" unless block_given?
      
      entity = NSEntityDescription.alloc.init
      entity.name = entity.managedObjectClassName = name.to_s
      proc.call(entity)
      add_entity(entity)
      entity
    end

    def drop_entity(name)
      raise ArgumentError, "Please provide a name for the entity to drop" if name.nil?
      entity = entity_for_name(name.to_s)
      
      raise ArgumentError, "An entity with the name '#{name}' could not be found" if entity.nil?
      remove_entity(entity)
    end
    
	end

end