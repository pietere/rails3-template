# Adding some config
say "Generating configuration".magenta
application File.open("#{@generators}/application.rb").read
gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'
gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery rails)'

gitc "Basic config"

# Get locales
unless @locale_str.empty?
  locales = @locale_str.split(",")
  locales.each do |loc|
    begin
      get("https://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/#{loc.strip}.yml", "config/locales/#{loc.strip}.yml")
    rescue OpenURI::HTTPError
      say "#{loc} doesn't exists".red.bold
    end
  end
end

gitc "Locale files"

# Generate RSpec
say "Generating rspec".magenta
generate 'rspec:install'

gitc "Rspec install"

# Generate cucumber at the end because of errors with celerity
say "Generating cucumber".magenta

generate 'cucumber:install --capybara'
generate 'pickle --path --email'
file "features/support/akephalos.rb", File.open("#{@generators}/akephalos.rb").read

gitc "Cubumber install"

# Generate configuration
generate 'nifty:config'

gitc "Nifty config"

# Generate compass install
say "Install the basic layout with compass and tabs_on_rails".magenta
srun "bundle exec compass init --using blueprint/basic --app rails --css-dir public/stylesheets/compiled --sass-dir app/stylesheets"

# Generate layout and scaffold for home
generate 'controller homes show'
route "root :to => 'homes#show'"
file "app/views/layouts/application.html.haml", File.open("#{@generators}/application.html.haml").read
file "app/views/layouts/_menu.html.haml", File.open("#{@generators}/_menu.html.haml").read
file "app/stylesheets/application.scss", File.open("#{@generators}/application.scss").read
file "config/initializers/menu_builder.rb", File.open("#{@generators}/menu_builder.rb").read
file "app/helpers/layout_helper.rb", File.open("#{@generators}/layout_helper.rb").read

gitc "Layout and homepage"

# Generate jquery, formtastic, devise
say "Generating jquery".magenta
generate 'jquery:install'

gitc "JQuery install"

#say "Generating formtastic".magenta
generate 'formtastic:install'

gitc "Formtastic install"

##say "Generating devise".magenta
##generate "devise:install"
##generate "devise User"

##gitc "Devise install"

