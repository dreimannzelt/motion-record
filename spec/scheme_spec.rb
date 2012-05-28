describe "Scheme" do
  
  it "should be able to create a scheme" do
    MotionRecord::Scheme.migrate
    MotionRecord::Manager.instance.entity_for_name(:Project).should.not.be.nil?
    MotionRecord::Manager.instance.entity_for_name(:Task).should.not.be.nil?
  end

end