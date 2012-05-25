describe "NSManagedObject" do
  
  before do
    $running_specs = true
    
    MotionRecord::Manager.entity_classes = [ Project, Task ]
    MotionRecord::Manager.instance.model.should.not.be.nil?
    MotionRecord::Manager.instance.coordinator.should.not.be.nil?
    MotionRecord::Manager.instance.store.should.not.be.nil?
    MotionRecord::Manager.instance.context.should.not.be.nil?
  end
  
  after do
    MotionRecord::Manager.instance.destroy
  end
  
  describe "base entity description" do
    
    it "should has a created_at property" do
      NSManagedObject.entity_description.properties.any? do |property|
        property.is_a?(NSAttributeDescription) && property.name == "created_at"
      end.should.be.equal true
    end
    
    it "should has a updated_at property" do
      NSManagedObject.entity_description.properties.any? do |property|
        property.is_a?(NSAttributeDescription) && property.name == "updated_at"
      end.should.be.equal true
    end
    
  end
  
  describe "subclass" do
    
    it "should use the class name as entity name" do
      Project.entity_description.name.should.equal "Project"
    end
    
    it "should use the class name as entity class name" do
      Project.entity_description.managedObjectClassName.should.equal "Project"
    end
    
    it "should has it's own properties" do
      Project.should.has_property?("title", :string)
      Project.should.has_property?("deadline", :date)
    end
    
  end

  describe "creation" do
    
    it "should be able to create a new entity instance" do
      project = Project.create
      project.should.be.is_a?(NSManagedObject)
      project.should.be.is_a?(Project)
      project.should.be.inserted?
    end
  
    it "should be able to initalize the properties of an new entity" do
      now = Time.new
      project = Project.create(:title => "MyProject", :deadline => now)
      project.title.should.be.equal "MyProject"
      project.deadline.should.be.equal now
    end
    
    it "should ignore unknown properties" do
      project = Project.create(:a_name => "Unknown")
      project.should.be.is_a?(NSManagedObject)
      project.should.be.is_a?(Project)
    end
    
  end
  
  describe "destory" do
    
    it "should be able to destroy an entity" do
      project = Project.create(:title => "MyProject", :deadline => Time.new)
      project.save
      project.destroy
      project.should.be.deleted?
    end
    
  end
  
  describe "Query" do
    
    it "should be able to find an entity by id" do
      project = Project.create(:title => "MyProject", :deadline => Time.new)
      project.save
      
      entity = Project.find(project.objectID)
      entity.should.not.be.nil?
      entity.should.be.equal project
    end
    
    it "should return nil if the entity id is" do
      entity = Project.find(nil)
      entity.should.be.nil?
    end
    
    it "should be able to find all entites of an entity type" do
      result = Project.find_all
      result.count.should.be.equal 0
      
      Project.create(:title => "MyProject 1", :deadline => Time.new).save
      Project.create(:title => "MyProject 2", :deadline => Time.new).save
      Project.create(:title => "MyProject 3", :deadline => Time.new).save
      
      result = Project.find_all
      result.count.should.be.equal 3
    end
    
    it "should be able to find entites by NSPredicate expression" do
      Project.create(:title => "MyProject 1", :deadline => Time.new).save
      Project.create(:title => "Project 2", :deadline => Time.new).save
      Project.create(:title => "MyProject 3", :deadline => Time.new).save
      
      result = Project.where("title LIKE 'MyProject 1' or title LIKE 'MyProject 3'")
      result.count.should.be.equal 2
    end
    
    it "should be able to find entites by a block" do
      Project.create(:title => "MyProject 1", :deadline => Time.new).save
      Project.create(:title => "Project 2", :deadline => Time.new).save
      Project.create(:title => "MyProject 3", :deadline => Time.new).save
      
      result = Project.where do |entity|
        puts "#{entity.description}"
        entity.title == "MyProject 1" || entity.title == "MyProject 3"
      end
      result.count.should.be.equal 2
    end
    
  end
  
end