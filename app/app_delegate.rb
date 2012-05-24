class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    MotionRecord::Manager.entity_classes = [ Project, Task ]
    MotionRecord::Manager.instance
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    true
  end
end
