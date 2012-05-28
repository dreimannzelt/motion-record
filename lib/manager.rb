module MotionRecord
  
  class Manager

    class << self
      
      def instance
        @instance ||= new
      end
      
      def rebuild_core_data_stack
        instance.destroy
        instance.coordinator
        instance.store
        instance.context
      end

    end
    
  public
    attr_reader :coordinator, :store, :context
    
    def coordinator
      @coordinator ||= begin
        NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(MotionRecord::Scheme.current_model)
      end
    end
  
    def store
      @store ||= begin
        url = create_url_for_environment
        error_ptr = Pointer.new(:object)
        store = coordinator.addPersistentStoreWithType(store_type_for_environment, configuration:nil, URL:url, options:nil, error:error_ptr)
        raise "Can't add persistent SQLite store: #{error_ptr[0].description}" unless store
        store        
      end
    end
    
    def context
      @context ||= begin
        context = NSManagedObjectContext.alloc.init
        context.persistentStoreCoordinator = coordinator
        context
      end
    end
    
    def execute_fetch_request(request, error:error)
      context.executeFetchRequest(request, error:error)
    end
    
    def entity_for_name(name)
      raise ArgumentName, "You must provide a name" if name.nil?
      NSEntityDescription.entityForName(name.to_s, inManagedObjectContext:context)
    end
    
    def new_object_for_name(name)
      raise ArgumentName, "You must provide a name" if name.nil?
      NSEntityDescription.insertNewObjectForEntityForName(name.to_s, inManagedObjectContext:context)
    end
  
    def save
      error = Pointer.new(:object)
      unless context.save(error)
        puts "Error when saving the model: #{error[0].description}"
        return false
      end
      true
    end
    
    def destroy
      return if @store.nil? || @coordinator.nil?
      error_ptr = Pointer.new(:object)
      coordinator.removePersistentStore(@store, error:error_ptr)
      puts "destroy: #{error_ptr[0].description}" if error_ptr[0]
      @coordinator = nil
      @store = nil
      @context = nil
    end
      
  private
      
    def create_url_for_environment
      return nil if $running_specs
      
      NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'development.sqlite')) 
    end
  
    def store_type_for_environment
      $running_specs ? NSInMemoryStoreType : NSSQLiteStoreType
    end
    
  end
  
end