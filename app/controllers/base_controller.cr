require "ecr/macros"

module Railslike
  module Controllers
    abstract class BaseController
      def initialize(@env : HTTP::Server::Context); end 

      def render(instance : BaseController)
        LayoutController.new(env, instance).render
      end 

      def self.to_proc
        ->(env : HTTP::Server::Context){

          # Instantiate new Controller/View
          controller = new(env)

          # Render own view through application template
          controller.render(controller)
        }   
      end

      def name
        self.class.name.split("::").last
      end 

      ECR.def_to_s \
        "#{`pwd`.chomp}/app/views/" +
        @type.name.id.
        split("::").last.
        split("Controller").first.
        downcase +
        ".ecr"

      macro inherited
        def content; self.to_s end 
      end 
      private getter :env
    end 
  end 
end
