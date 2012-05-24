# ActiveRecord (based on CoreData) for RubyMotion

ActiveRecord like wrapper for CoreData.
	
## Getting started

Add motion-record as a git submodule of your RubyMotion project:

    git clone https://github.com/dreimannzelt/motion-record.git vendor/motion-record

Add the motion-record lib path to your project 'Rakefile'

```ruby
Motion::Project::App.setup do |app|
  app.name = 'MyApp'
  app.files.unshift(Dir.glob(File.join(app.project_dir, 'vendor/motion-record/lib/**/*.rb')))
end
```

## License

motion-record is released under the MIT license:

http://www.opensource.org/licenses/MIT