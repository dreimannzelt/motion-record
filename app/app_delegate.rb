class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)    
    MotionRecord::Scheme.migrate [ Project, Task ]
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    true
  end
end
