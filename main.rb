require 'colored'

def gitc msg
  git :add => "."
  git :commit => %Q{-am "#{msg}"}
end

def srun cmd
  run cmd, :capture => true
end

@root = File.dirname(__FILE__)
@generators = "#{@root}/generators"

# Get the list of locales
@locale_str = ask("Enter list of locales to use separated by commas (default = nl, en is always added; don't add it again :) )")
@locale_str = "nl" if @locale_str.blank?

# Set up everything
removeable_files = %w[.gitignore README public/index.html public/images/rails.png ]
removeable_files.each do |file|
  remove_file file
end
file ".gitignore", File.open("#{@generators}/gitignore").read

emptyable_dirs = %w[public/javascripts app/views/layouts]
emptyable_dirs.each do |dir|
  remove_file dir
  empty_directory dir
end

git :init => "."
gitc "Initial commit, rails basic install"

# Apply templates
%w[gems rvm generators].each do |template|
  apply "#{@root}/#{template}.rb"
end

rake 'db:create'

say 'DONE!'.green.bold
