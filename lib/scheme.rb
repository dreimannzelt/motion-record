module MotionRecord

	class Scheme
    
    def print_config
      puts "$running_specs             => #{$running_specs}"
      puts "store_type_for_environment => #{store_type_for_environment}"
      puts "url_for_environment        => #{url_for_environment.description}"
      puts "store_meta_data            => #{store_meta_data}"
    end
    
    class << self
      
      attr_accessor :current_model
            
      def migrate
        all_migrations = MotionRecord::Migration.all_migrations
        raise "No versions for migration found" if all_migrations.nil? || all_migrations.empty?
        neweset_migration = MotionRecord::Migration.neweset_migration
        
        if store_exists?
          if migration_is_needed?
            compatible_version = all_migrations.reverse.find { |v| v.is_compatible_with?(store_meta_data) }
            compatible_version = all_migrations.first if compatible_version.nil?
          
            start = all_migrations.index(compatible_version)
            length = all_migrations.count-start
            versions_to_migrate = all_migrations[start, length]
          
            from_version = compatible_version
            versions_to_migrate.each do |to_version|
              migrate_store(from_version, to_version)
              from_version = to_version
            end
          else
            @current_model = neweset_migration
          end
        else
          if all_migrations.count > 1
            @current_model = NSManagedObjectModel.modelByMergingModels(all_migrations)
          else
            @current_model = neweset_migration
          end
        end
        
        MotionRecord::Manager.rebuild_core_data_stack
      end
      
      def destroy
        MotionRecord::Manager.instance.destroy
      end
      
    private
      def store_exists?
        !store_meta_data.nil?   
      end
    
      def migration_is_needed?
        !MotionRecord::Migration.neweset_migration.is_compatible_with?(store_meta_data)
      end
      
      def store_meta_data
        error_ptr = Pointer.new(:object)
        data = NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(store_type_for_environment, URL:url_for_environment, error:error_ptr)
        raise "Could not create meta data for persistent store: #{error_ptr[0].description}" if error_ptr[0]
        data
      end
      
      def url_for_environment
        filename = $running_specs ? 'specs.sqlite' : 'development.sqlite'
        NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', filename)) 
      end
  
      def store_type_for_environment
        $running_specs ? NSInMemoryStoreType : NSSQLiteStoreType
      end
      
      def migrate_store(from_version, to_version)
        destination_url = url_for_environment.URLByAppendingPathExtension("new")
        
        error_ptr = Pointer.new(:object)
        mapping_model = to_version.mapping_model
        if mapping_model.nil?
          mapping_model = NSMappingModel.inferredMappingModelForSourceModel(from_version, destinationModel:to_version, error:error_ptr)
          puts "#{error_ptr[0].description}" if error_ptr[0]
        end
        return false if mapping_model.nil?
        
        error_ptr = Pointer.new(:object)
        manager = NSMigrationManager.alloc.initWithSourceModel(from_version, destinationModel:to_version)
        result = manager.migrateStoreFromURL(url_for_environment,
                            type:store_type_for_environment,
                            options:nil,
                            withMappingModel:mapping_model,
                            toDestinationURL:destination_url,
                            destinationType:store_type_for_environment,
                            destinationOptions:nil,
                            error:error_ptr)
        puts "#{error_ptr[0].description}" if error_ptr[0]
        return false unless result

        error_ptr = Pointer.new(:object)
        result_url = Pointer.new(:object)
        result = NSFileManager.defaultManager.replaceItemAtURL(url_for_environment, withItemAtURL:destination_url, backupItemName:"backup.sqlite", options:0, resultingItemURL:result_url, error:error_ptr)
        puts "#{error_ptr[0].description}" if error_ptr[0]
        return false unless result
        
        true
      end
      
    end

	end
  
end
