require 'middleman-core/util'

module Middleman
  module Org

    class OrgData
      attr_reader :options
      attr_reader :controller

      def initialize(app, controller, options)
        @app = app
        @options = options
        @controller = controller

        @_articles = []
      end

      def articles
        @_articles
      end

      def tags
        []
      end

      def manipulate_resource_list(resources)
        @_posts = []
        resources.each do |resource|
          next unless resource.path =~ /^#{options.root}/

          if options.prefix
            resource.destination_path = resource
              .path
              .gsub(/^#{options.root}/,
                    options.prefix)
          end
          if File.extname(resource.source_file) == '.org'
            article = convert_to_article resource
            next unless publishable?(article)
            @_articles << article
          end
        end
      end

      def publishable?(article)
        @app.environment == :development || article.published?
      end

      def convert_to_article(resource)
        return resource if resource.is_a?(OrgArticle)
        resource.extend OrgArticle
        resource.org_controller = controller
        resource
      end

    end
  end
end
