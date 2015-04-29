module Middleman
  module Org
    def self.instances
      @org_instances ||= {}
    end

    def self.instances=(v)
      @org_instances = v
    end

    module Helpers
      def self.included(base)
        ::Middleman::Org.instances = {}
      end

      def org_instances
        ::Middleman::Org.instances
      end

      def org_controller(org_name = nil)
        # Warn if a non-existent org name provided
        if org_name && !org_instances.keys.include?(org_name.to_sym)
          fail "Non-existent org name provided: #{org_name}."
        end

        org_name ||= org_instances.keys.first
        org_instances[org_name.to_sym]
      end

      def org_data(org_name = nil)
        org_controller(org_name).data
      end

      def org_article?
        !current_article.nil?
      end

      def current_article
        article = current_resource
        if article && article.is_a?(OrgArticle)
          article
        else
          nil
        end
      end

      def articles(org_name = nil)
        org_data(org_name).articles
      end
    end
  end
end
