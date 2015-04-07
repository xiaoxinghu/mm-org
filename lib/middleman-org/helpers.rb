module Middleman
  module Org

    def self.controller
      @controller ||= nil
    end

    def self.controller=(v)
      @controller = v
    end

    module Helpers
      def self.included(base)
      end

      def org_controller
        ::Middleman::Org.controller
      end

      def org_data
        org_controller.data
      end

      def current_article
        article = current_resource
        if article && article.is_a?(OrgArticle)
          article
        else
          nil
        end
      end

      def articles
        org_data.articles
      end
    end
  end
end
