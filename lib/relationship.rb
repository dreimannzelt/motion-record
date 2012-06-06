module MotionRecord

  class Relationship
    attr_accessor :name, :target_class, :inverse, :delete_rule, :min, :max, :ordered
    
    def initialize(name)
      @name = name.to_s
    end

  end

end