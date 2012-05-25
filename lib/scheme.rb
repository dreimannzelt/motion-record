module MotionRecord

	class Scheme
    
    class << self
      
      def migrate(klasses)
        MotionRecord::Manager.entity_classes = klasses
        MotionRecord::Manager.instance
      end
      
    end

	end
  
end