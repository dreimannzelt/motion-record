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

## Create and destroy

Properties for "created_at" and "updated_at" will be added to every NSManagedObject subclass automatically. 

```ruby
class Project < NSManagedObject  
  property :title, :string
  property :deadline, :date
end
```

```ruby
project = Project.create(:title => "MyProject 1", :deadline => Time.new)
project.save

project.destroy
project.save
```

## Query

```ruby
project = Project.find(object_id)

all = Project.all

projects = Project.where("title CONTAINS[cd] 'motion'")

count_of_all = Project.count
count = Project.count("title CONTAINS[cd] 'motion'")

sorted_projects = Project.order(:created_at)
```


## License

motion-record is released under the MIT license:

http://www.opensource.org/licenses/MIT