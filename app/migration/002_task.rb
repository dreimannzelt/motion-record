MotionRecord::Version.define 2 do |v|
  
  v.create_entity :Task do |e|
    e.string    :title,   :default => ""
    e.date      :deadline

    e.has_one   :project      
    e.timestamps
  end
  
  v.entity :Project do |e|
    e.has_many :tasks, :class => :Task
  end
  
end