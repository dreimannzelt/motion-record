class CreateTask < MotionRecord::Migration
  version 2
  
  def migrate
    create_entity :Task do |e|
      e.string    :title,   :default => ""
      e.date      :deadline
      e.timestamps
    end
  end
    
end

