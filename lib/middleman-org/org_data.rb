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
          next unless File.extname(resource.source_file) == '.org'
          article = convert_to_article resource
          next unless publishable?(article)

          update_dest(article)
          @_articles << article
          puts "------------"
          puts "is_OrgArticle?: #{resource.is_a?(OrgArticle)}"
          puts "path: #{resource.path}"
          puts "dpath: #{resource.destination_path}"
          puts "src: #{resource.source_file}"
          puts "url: #{resource.url}"
          puts "ext: #{resource.ext}"
          puts "ori ext: #{File.extname(resource.source_file)}"
          puts "content type: #{resource.content_type}"
          puts "meta: #{resource.metadata}"
        end
      end

      def update_dest(article)
        p = File.basename(article.destination_path)
        p = File.join(options.prefix, p) if options.prefix
        p = Addressable::URI.unencode(p).to_s
        article.destination_path = ::Middleman::Util.normalize_path(p)
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
