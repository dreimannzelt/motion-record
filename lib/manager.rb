module MotionRecord
  
  class Manager
    attr_accessor :model, :store, :context
  
  public
    def self.shared
      @shared ||= Manager.new
    end

    def self.entity_classes
      @@entity_classes
    end
  
    def self.entity_classes=(new_entity_classes)
      @@entity_classes = new_entity_classes
    end
    
    def self.entity_for_name(name)
      NSEntityDescription.entityForName(name, inManagedObjectContext:shared.context)
    end
  
    def self.new_object_for_name(name)
      NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext:shared.context)
    end
  
    def save
      error = Pointer.new(:object)
      unless @context.save(error)
        puts "Error when saving the model: #{error[0].description}"
        return false
      end
      true
    end
  
    def execute_fetch_request(request, error:error)
      @context.executeFetchRequest(request, error:error)
    end
      
  private
    def initialize 
      setup_model
      setup_store
      setup_context
    end
  
    def setup_model
      model = NSManagedObjectModel.alloc.init
      model.entities = Manager.entity_classes.map { |klass| klass.entity }
      @model = model
    end
  
    def create_entities
      subclasses.map { |subclass| subclass.entity }
    end
    
    def subclasses
      # RubyMotion dosen't support ObjectSpace.each_object at the moment :-/
      return []
      
      class_hash = {}
      ObjectSpace.each_object do |obj|
        if NSManagedObject == obj.class
          if obj.ancestors.include? self
            class_hash[obj] = true
          end
        end
      end
      class_hash.keys
    end
  
    def setup_store
      store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(@model)
      url = create_url_for_environment
      error = Pointer.new(:object)
      unless store.addPersistentStoreWithType(store_type_for_environment, configuration:nil, URL:url, options:nil, error:error)
        raise "Can't add persistent SQLite store: #{error[0].description}"
      end
      @store = store
    end
  
    def create_url_for_environment
      # we a way to know which environment is used (e.g. running specs in simulator)
      filename = 'development.sqlite'
      NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', filename)) 
    end
  
    def store_type_for_environment
      # we a way to know which environment is used (e.g. running specs in simulator)
      NSSQLiteStoreType
    end
  
    def setup_context
      context = NSManagedObjectContext.alloc.init
      context.persistentStoreCoordinator = @store
      @context = context
    end
  end
  
end