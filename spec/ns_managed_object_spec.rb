describe "NSManagedObject" do
    
  describe "creation" do
    before do MotionRecord::Scheme.migrate end
    after do MotionRecord::Scheme.destroy end
    
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
  
  describe "destorying" do
    before do MotionRecord::Scheme.migrate end
    after do MotionRecord::Scheme.destroy end
    
    it "should be able to destroy an entity" do
      project = Project.create(:title => "MyProject", :deadline => Time.new)
      project.save
      project.destroy
      project.should.be.deleted?
    end
    
  end
  
  describe "querying" do
    before do MotionRecord::Scheme.migrate end
    after do MotionRecord::Scheme.destroy end
    
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
      result = Project.all
      result.count.should.be.equal 0
      
      Project.create(:title => "MyProject 1", :deadline => Time.new).save
      Project.create(:title => "MyProject 2", :deadline => Time.new).save
      Project.create(:title => "MyProject 3", :deadline => Time.new).save
      
      result = Project.all
      result.count.should.be.equal 3
    end
    
    it "should be able to find entites by NSPredicate expression" do
      Project.create(:title => "MyProject 1", :deadline => Time.new).save
      Project.create(:title => "Project 2", :deadline => Time.new).save
      Project.create(:title => "MyProject 3", :deadline => Time.new).save
      
      result = Project.where("title LIKE 'MyProject 1' or title LIKE 'MyProject 3'")
      result.count.should.be.equal 2
    end
    
    it "should be able to count the number of an entity" do
      Project.create(:title => "MyProject 1", :deadline => Time.new).save
      Project.create(:title => "Project 2", :deadline => Time.new).save
      Project.create(:title => "MyProject 3", :deadline => Time.new).save
      
      Project.count.should.be.equal 3
    end
    
    it "should be able to count the number of an entity filtered by an expression" do
      Project.create(:title => "MyProject 1", :deadline => Time.new).save
      Project.create(:title => "Project 2", :deadline => Time.new).save
      Project.create(:title => "MyProject 3", :deadline => Time.new).save
      
      Project.count("title CONTAINS[cd] 'My'").should.be.equal 2
    end
    
    it "should be able to sort entities by a property" do
      first = Project.create(:title => "A", :deadline => Time.new).save
      second = Project.create(:title => "B", :deadline => Time.new).save
      three = Project.create(:title => "C", :deadline => Time.new).save
      
      result = Project.order(:title)
      result[0].should.be.equal first
      result[1].should.be.equal second
      result[2].should.be.equal three
    end
    
    it "should be able to sort entities by a property in descending order" do
      first = Project.create(:title => "A", :deadline => Time.new)
      first.save
      second = Project.create(:title => "B", :deadline => Time.new)
      second.save
      three = Project.create(:title => "C", :deadline => Time.new)
      three.save
      
      result = Project.order(:title, false)
      result[0].should.be.equal three
      result[1].should.be.equal second
      result[2].should.be.equal first
    end
  
  end
  
end