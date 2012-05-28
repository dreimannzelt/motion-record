describe "Migration" do
  
  before do
    @migration = MotionRecord::Migration.new
  end
  
  after do
    @migration = nil
  end
  
  it "should be able to find all migrations" do
    MotionRecord::Migration.all_migrations.count.should.be.equal 2
  end
  
  it "should be able to find the neweset migration" do
    MotionRecord::Migration.neweset_migration.class.version_number.should.be.equal 2
  end

  it "should be able to create an entity" do
    entity = @migration.create_entity(:Project) do |e| end
    entity.should.not.be.nil?
  end
  
  it "raises an exception if the name for the entity to create is nil" do
    lambda {
      @migration.create_entity(nil) do |e| end
    }.should.raise(ArgumentError)
     .message.should.be.equal "Please provide a name for the entity to create"
  end
  
  it "raises an exception if no block is given for the entity to create" do
    lambda {
      @migration.create_entity(:Project)
    }.should.raise(ArgumentError)
     .message.should.be.equal "Please provide a block which describes the entity"
  end
  
  it "should be able to drop an entity" do
    entity = @migration.create_entity(:Project) do |e| end
    @migration.drop_entity(:Project)
    @migration.entities.count.should.be.equal 0
  end
  
  it "raises an exception if the name for the entity to drop is nil"do
    entity = @migration.create_entity(:Project) do |e| end
    lambda {
      @migration.drop_entity(nil)
    }.should.raise(ArgumentError)
     .message.should.be.equal "Please provide a name for the entity to drop"
  end
  
  it "raises an exception if no entity was found for the entity to drop" do
    lambda {
      @migration.drop_entity(:Project)
    }.should.raise(ArgumentError)
     .message.should.be.equal "An entity with the name 'Project' could not be found"
  end
  
end