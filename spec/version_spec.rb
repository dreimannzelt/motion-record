describe "Version" do

  it "should be able to create a new model version" do
    MotionRecord::Version.define 100 { |v| }    
    MotionRecord::Version.versions.should.any? { |v| v.number == 100 }
  end

end