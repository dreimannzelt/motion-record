describe "Manager" do
  
  before do
    MotionRecord::Scheme.migrate
  end
  
  after do
    MotionRecord::Scheme.destroy
  end
    
  it "should be able to create an description for entity name" do
    desc = MotionRecord::Manager.instance.entity_for_name(Task.to_s)
    desc.name.should.be.equal "Task"
  end
  
  it "should be able to create a new object for an entity class" do
    entity = MotionRecord::Manager.instance.new_object_for_name(Task.to_s)
    entity.managedObjectContext.should.equal MotionRecord::Manager.instance.context
  end
  
  it "should be able to save the current context" do
    entity = MotionRecord::Manager.instance.new_object_for_name(Task.to_s)
    entity.managedObjectContext.should.equal MotionRecord::Manager.instance.context
    MotionRecord::Manager.instance.save.should.be.equal true
  end
  
  it "should be able to execute a fetch request" do
    error_ptr = Pointer.new(:object)
    request = NSFetchRequest.alloc.init
    request.entity = MotionRecord::Manager.instance.entity_for_name(Task.to_s)
    all = MotionRecord::Manager.instance.execute_fetch_request(request, error:error_ptr)
    error_ptr[0].should.be.nil?
    all.should.not.be.nil?
  end
  
end