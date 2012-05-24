$:.unshift("/Library/RubyMotion/lib")

require 'rubygems'
require 'motion/project'
require 'motion-redgreen'

Motion::Project::App.setup do |app|
  app.name = 'motion-record'
  
  # Libraries
  app.files.unshift(Dir.glob(File.join(app.project_dir, 'lib/**/*.rb')))
  
  # Frameworks
  app.frameworks += [ 'CoreData' ]
  
  # Redgreen
  app.redgreen_style = :full
end
