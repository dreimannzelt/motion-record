describe "NSManagedObjectModel extension" do
  
  it "should be able to add an entity" do
    entity = NSEntityDescription.alloc.init
    entity.name = entity.managedObjectClassName = "Project"
    model = NSManagedObjectModel.alloc.init
    model.add_entity(entity)
    model.entities.count.should.be.equal 1
  end
  
  it "should be able to remove an entity" do
    entity = NSEntityDescription.alloc.init
    entity.name = entity.managedObjectClassName = "Project"
    model = NSManagedObjectModel.alloc.init
    model.add_entity(entity)
    model.entities.count.should.be.equal 1
    
    model.remove_entity(entity)
    model.entities.count.should.be.equal 0
  end

end