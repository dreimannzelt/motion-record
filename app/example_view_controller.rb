class ExampleViewController < UIViewController

	def viewDidLoad
    migrate_button = UIButton.buttonWithType UIButtonTypeRoundedRect
    migrate_button.frame = [[50,50], [100,44]]
    migrate_button.setTitle("Migrate", forState:UIControlStateNormal)
    migrate_button.addTarget(self, action:"migrate", forControlEvents:UIControlEventTouchUpInside)
    view.addSubview migrate_button

    destroy_button = UIButton.buttonWithType UIButtonTypeRoundedRect
    destroy_button.frame = [[50,150], [100,44]]
    destroy_button.setTitle("Destroy", forState:UIControlStateNormal)
    destroy_button.addTarget(self, action:"destory", forControlEvents:UIControlEventTouchUpInside)
    view.addSubview destroy_button
	end
  
  # Actions
  def migrate
    MotionRecord::Scheme.migrate
  end
  
  def destory
    MotionRecord::Scheme.destroy
  end

end