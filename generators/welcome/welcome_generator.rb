class WelcomeGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
    
      # the controller
      m.template 'controllers/welcome_controller.rb',
        "app/controllers/#{file_name}_controller.rb"
        
      # the views
      m.directory "app/views/#{file_name}"
      m.template 'views/welcome/index.html.erb',
        "app/views/#{file_name}/index.html.erb"
      m.template 'views/welcome/about.html.erb',
        "app/views/#{file_name}/about.html.erb"
      
      # the layout
      m.file 'views/layouts/main.html.erb',
        "app/views/layouts/#{file_name}.html.erb"
      m.file 'public/stylesheets/main.css',
        "public/stylesheets/main.css"

      m.root_route :controller => file_name

      
      m.readme 'INSTALL'
    end
  end
end

# thanx to Pat Shaughnessy for this part of the code
module Rails
  module Generator
    module Commands

      class Base
        def route_code(route_options)
          "map.root :controller => '#{route_options[:controller]}'"
        end
      end

      class Create
        def root_route(route_options)
          sentinel = 'ActionController::Routing::Routes.draw do |map|'
          logger.route route_code(route_options)
          gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |m|
              "#{m}\n  #{route_code(route_options)}\n"
          end
        end
      end

      class Destroy
        def root_route(route_options)
          logger.remove_route route_code(route_options)
          to_remove = "\n  #{route_code(route_options)}"
          gsub_file 'config/routes.rb', /(#{to_remove})/mi, ''
        end
      end

    end
  end
end