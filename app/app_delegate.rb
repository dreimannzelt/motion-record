class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    #MotionRecord::Scheme.migrate
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    @window.rootViewController = ExampleViewController.alloc.init
    true
  end
end
