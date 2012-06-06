MotionRecord::Version.define 1 do |v|
  
  v.create_entity :Project do |e|
    e.string    :title,    :default => ""
    e.date      :deadline
    e.integer16 :priority, :default => 1
    e.boolean   :finsihed, :default => false
      
    e.timestamps
  end
  
end


