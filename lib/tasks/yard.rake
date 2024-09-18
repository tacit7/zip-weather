namespace :yard do
  desc "Generate YARD documentation"
  task :generate do
    puts "Generating documentation..."
    system("bundle exec yard doc app/**/*.rb lib/**/*.rb") # Customize path if necessary
  end
end
