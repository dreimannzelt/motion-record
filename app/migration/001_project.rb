class CreateProject < MotionRecord::Migration
  version 1
  
  def migrate
    create_entity :Project do |e|
      e.string    :title,    :default => ""
      e.date      :deadline
      e.integer16 :priority, :default => 1
      e.boolean   :finsihed, :default => false
      e.timestamps
    end
  end
    
end

