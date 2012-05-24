describe "Manager" do
  
  before do
    $running_specs = true
    
    MotionRecord::Manager.entity_classes = [ Project, Task ]
    MotionRecord::Manager.shared
    MotionRecord::Manager.shared.model.should.not.be.nil?
    MotionRecord::Manager.shared.store.should.not.be.nil?
    MotionRecord::Manager.shared.context.should.not.be.nil?
  end
  
  it "should be able to store all entity classes" do
    MotionRecord::Manager.entity_classes.should.include?(Project)
    MotionRecord::Manager.entity_classes.should.include?(Task)
  end
  
  it "should be able to create an description for entity name" do
    desc = MotionRecord::Manager.entity_for_name(Task.to_s)
    desc.name.should.be.equal "Task"
  end
  
  it "should be able to create a new object for an entity class" do
    entity = MotionRecord::Manager.new_object_for_name(Task.to_s)
    entity.managedObjectContext.should.equal MotionRecord::Manager.shared.context
  end
  
  it "should be able to save the current context" do
    entity = MotionRecord::Manager.new_object_for_name(Task.to_s)
    entity.managedObjectContext.should.equal MotionRecord::Manager.shared.context
    MotionRecord::Manager.shared.save.should.be.equal true
  end
  
  it "should be able to execute a fetch request" do
    error_ptr = Pointer.new(:object)
    request = NSFetchRequest.alloc.init
    request.entity = MotionRecord::Manager.entity_for_name(Task.to_s)
    all = MotionRecord::Manager.shared.execute_fetch_request(request, error:error_ptr)
    error_ptr[0].should.be.nil?
    all.should.not.be.nil?
  end
  
end