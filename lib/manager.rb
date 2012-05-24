module MotionRecord
  
  class Manager
    attr_reader :model, :coordinator, :store, :context
  
  public
    def self.shared
      @shared ||= Manager.new
    end

    def self.entity_classes
      @@entity_classes ||= [ ]
    end
  
    def self.entity_classes=(new_entity_classes)
      @@entity_classes = new_entity_classes
    end
    
    def self.entity_for_name(name)
      NSEntityDescription.entityForName(name.to_s, inManagedObjectContext:shared.context)
    end
  
    def self.new_object_for_name(name)
      NSEntityDescription.insertNewObjectForEntityForName(name.to_s, inManagedObjectContext:shared.context)
    end
    
    def save
      error = Pointer.new(:object)
      unless @context.save(error)
        puts "Error when saving the model: #{error[0].description}"
        return false
      end
      true
    end
    
    def destroy
      error = Pointer.new(:object)
      @coordinator.removePersistentStore(@store, error:error)
      unless error
        puts "destroy: #{error[0].description}"
      end
      @store = nil  
    end
  
    def execute_fetch_request(request, error:error)
      @context.executeFetchRequest(request, error:error)
    end
      
    def model
      @model ||= begin
        model = NSManagedObjectModel.alloc.init
        model.entities = Manager.entity_classes.map { |klass| klass.entity }
        model        
      end
    end
  
    def coordinator
      @coordinator ||= begin
        NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
      end
    end
  
    def store
      @store ||= begin
        url = create_url_for_environment
        error = Pointer.new(:object)
        store = coordinator.addPersistentStoreWithType(store_type_for_environment, configuration:nil, URL:url, options:nil, error:error)
        unless store
          raise "Can't add persistent SQLite store: #{error[0].description}"
        end
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
      
  private
    def initialize 
      model
      coordinator
      store
      context
    end
  
    def create_url_for_environment
      filename = $running_specs ? 'specs.sqlite' : 'development.sqlite'
      NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', filename)) 
    end
  
    def store_type_for_environment
      $running_specs ? NSInMemoryStoreType : NSSQLiteStoreType
    end
    
  end
  
end