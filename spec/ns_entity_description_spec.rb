describe "NSEntityDescription extension" do
  
  before do
    @entity = NSEntityDescription.alloc.init
    @entity.name = @entity.managedObjectClassName = "Task"
  end
  
  after do
    @entity = nil
  end

  it "should be able to add a property" do
    @entity.add_property(:priority, :integer16, :required => false, :default => 1000)
    
    @entity.properties.count.should.be.equal 1
    @entity.properties[0].name.should.be.equal "priority"
    @entity.properties[0].attributeType.should.be.equal NSInteger16AttributeType
    @entity.properties[0].should.be.optional?
    @entity.properties[0].defaultValue.should.be.equal 1000
  end
  
  it "should be able to add timestamps" do
    @entity.timestamps
    has_property? "created_at", NSDateAttributeType
    has_property? "updated_at", NSDateAttributeType
  end
  
  it "should be able to create a string attribute" do
    @entity.string :title
    has_property? "title", NSStringAttributeType
  end
  
  it "should be able to create integer attributes" do
    @entity.integer16 :prio16
    @entity.integer32 :prio32
    @entity.integer64 :prio64
    
    has_property? "prio16", NSInteger16AttributeType
    has_property? "prio32", NSInteger32AttributeType
    has_property? "prio64", NSInteger64AttributeType
  end
  
  it "should be able to create a boolean attribute" do
    @entity.boolean :finished
    has_property? "finished", NSBooleanAttributeType
  end
  
  it "should be able to create a date attribute" do
    @entity.date :deadline
    has_property? "deadline", NSDateAttributeType
  end
  
  it "should be able to create a decimal attribute" do
    @entity.decimal :total_sum 
    has_property? "total_sum", NSDecimalAttributeType
  end
  
  it "should be able to create a float attribute" do
    @entity.float :rate
    has_property? "rate", NSFloatAttributeType
  end
  
  it "should be able to create a double attribute" do
    @entity.double :rate
    has_property? "rate", NSDoubleAttributeType
  end
  
  it "should be able to create a binary attribute" do
    @entity.binary :image
    has_property? "image", NSBinaryDataAttributeType
  end

  it "should be able to create a transformable attribute" do
    @entity.transformable :image
    has_property? "image", NSTransformableAttributeType
  end
  
  # Helper
  
  def has_property?(name, type)
    @entity.properties.should.be.any? do |p|
      p.name == name && p.attributeType == type
    end
  end

end
